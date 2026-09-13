#!/usr/bin/env python3
"""Pangolin client adapter. Python standard library only; no shell evaluation."""
import argparse
import errno
import fcntl
import http.client
import ipaddress
import json
import os
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import time
import urllib.error
import urllib.request
from urllib.parse import quote, urlencode, urlsplit

ROOT = Path(__file__).resolve().parent
CONFIG = Path(os.environ.get('XDG_CONFIG_HOME', str(Path.home()/'.config')))/'omarchy-pangolin/config.json'
ACCOUNTS = Path(os.environ.get('XDG_CONFIG_HOME', str(Path.home()/'.config')))/'pangolin/accounts.json'
SOCKET = '/run/olm.sock'


class UserError(Exception):
    pass


def settings():
    if not CONFIG.exists():
        return {}
    try:
        data = json.loads(CONFIG.read_text())
        if not isinstance(data, dict) or data.get('schemaVersion', 1) != 1:
            raise ValueError()
        return data
    except (OSError, ValueError):
        raise UserError('Invalid local configuration. See docs/configuration.md.')


def web_url(value):
    if not isinstance(value, str) or any(ord(c) < 32 or c.isspace() for c in value):
        return ''
    try:
        p = urlsplit(value)
        if p.scheme not in ('http', 'https') or not p.hostname or p.username or p.password or '\\' in value:
            return ''
        if p.port is not None and not 0 < p.port < 65536:
            return ''
        return value
    except ValueError:
        return ''


def account():
    try:
        data = json.loads(ACCOUNTS.read_text())
        a = data['accounts'][data['activeuserid']]
        host = a['host'].rstrip('/')
        if not web_url(host) or urlsplit(host).scheme != 'https' or not a['sessionToken'] or not a['orgId']:
            raise ValueError()
        return dict(host=host, token=a['sessionToken'], org=str(a['orgId']))
    except (OSError, ValueError, KeyError, TypeError):
        raise UserError('Sign in with pangolin login and select an organization first.')


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, *args):
        return None


def api(a, path):
    req = urllib.request.Request(a['host']+'/api/v1/org/'+quote(a['org'], safe='')+path,
        headers={'Cookie': 'p_session_token='+a['token'], 'X-CSRF-Token': 'x-csrf-protection', 'Accept':'application/json'})
    try:
        with urllib.request.build_opener(NoRedirect()).open(req, timeout=4) as r:
            data = json.load(r)
        if data.get('success') is not True:
            raise ValueError()
        return data['data']
    except urllib.error.HTTPError as e:
        if e.code in (401,403):
            raise UserError('Session expired or access denied. Check your Pangolin account.')
        raise UserError('Pangolin API request failed (HTTP '+str(e.code)+').')
    except (OSError, ValueError, KeyError):
        raise UserError('Cannot read Pangolin resources. Check the server and connection.')


def pages(a, path, key, extra=None):
    rows = []
    for page in range(1, 101):
        data = api(a, path+'?'+urlencode(dict(extra or {}, page=page, pageSize=100)))
        rows.extend(data[key])
        if page*100 >= data['pagination']['total']:
            return rows
    raise UserError('Resource list exceeds the supported size.')


class LocalConnection(http.client.HTTPConnection):
    def connect(self):
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.settimeout(self.timeout)
        self.sock.connect(SOCKET)


def local(method='GET', path='/status'):
    c = LocalConnection('localhost', timeout=3)
    try:
        c.request(method, path)
        r = c.getresponse()
        if r.status != 200:
            raise UserError('Local client API returned HTTP '+str(r.status))
        return json.loads(r.read(1024*1024))
    finally:
        c.close()


def classify(d):
    if not isinstance(d, dict) or any(type(d.get(k)) is not bool for k in ('connected','registered','terminated')):
        raise ValueError('Invalid status')
    peers = [p for p in (d.get('peers') or {}).values() if isinstance(p,dict)]
    online = sum(p.get('connected') is True for p in peers)
    state, label = 'warning', 'Registered · tunnel on demand'
    if d['terminated']:
        state, label = 'off', 'Disconnected'
    elif d.get('error'):
        state, label = 'error', 'Client error'
    elif not d['registered']:
        state, label = 'warning', 'Registration pending'
    elif not d['connected']:
        state, label = 'warning', 'Server connection interrupted'
    elif online or (d.get('exitNode') or {}).get('connected') is True:
        state, label = 'connected', 'Connected'
    network = d.get('networkSettings') or {}
    return dict(state=state,label=label,running=not d['terminated'],registered=d['registered'],
        websocket=d['connected'],peerCount=online,peerTotal=len(peers),
        tunnelIp=', '.join(network.get('ipv4_addresses') or []),
        dns=', '.join(network.get('dns_servers') or []),
        detail='Tunnel state does not verify each application.',
        peers=[dict(name=str(p.get('name','Site')),connected=p.get('connected') is True) for p in peers])


def status():
    try:
        return classify(local())
    except OSError as e:
        if e.errno in (errno.ENOENT, errno.ECONNREFUSED):
            return dict(state='off',label='Disconnected',running=False,detail='No local Pangolin client.')
    except (ValueError, TypeError, AttributeError, UserError, http.client.HTTPException):
        pass
    return dict(state='unknown',label='Status unavailable',running=None,detail='Cannot read the local client status.')


def normalize(r, detail, config, apps):
    address = str(r.get('accessCopyValue') or r.get('accessDisplay') or '')
    rid = str(r['launcherResourceKey'])
    url = web_url(r.get('accessUrl'))
    overrides = config.get('webUrls', {})
    # Overrides are scoped by server and organization by resources().
    override = overrides.get(rid)
    if override is not None:
        url = web_url(override)
        if not url:
            raise UserError('An override in webUrls is not a valid HTTP(S) URL.')
    ports = str((detail or {}).get('tcpPortRangeString') or '')
    # Never guess HTTP from a TCP port number; only use configured schemes.
    scheme = config.get('hostSchemes', {}).get(address)
    if not url and r.get('mode') == 'host' and scheme in ('http','https') and ports.isascii() and ports.isdecimal() and 0 < int(ports) < 65536:
        host = '['+address+']' if ':' in address else address
        if not any(c in address for c in '/?#*\\'):
            url = web_url(scheme+'://'+host+':'+ports+'/')
    desktop = next((name for name, urls in apps.items() if url and urls is not None and url.rstrip('/') in urls), None)
    site = r.get('site') or {}
    return dict(id=rid,name=str(r['name']),url=url,address=address,ports=ports,
        internal=r.get('resourceType')=='site',mode=str(r.get('mode','')),
        enabled=r.get('enabled') is True,site=str(site.get('name','')),siteOnline=site.get('online'),
        desktop=desktop,appInstalled=desktop is not None)


def resources():
    from webapps import installed_apps
    a = account()
    config = settings().get('accounts', {}).get(a['host'], {}).get(a['org'], {})
    rows = pages(a, '/launcher/resources','resources', {'groupKey':'all'})
    details = {}
    try:
        details = {'site:'+str(r['siteResourceId']):r for r in pages(a,'/site-resources','siteResources')}
    except UserError:
        pass  # Non-admin accounts keep their authorized launcher resources.
    apps = installed_apps()
    return [normalize(r,details.get(r['launcherResourceKey']),config,apps) for r in rows]


def notify(message):
    if shutil.which('notify-send'):
        subprocess.run(['notify-send','Pangolin for Omarchy',message],check=False)


def action(mode):
    runtime = Path(os.environ.get('XDG_RUNTIME_DIR', '/tmp'))
    with (runtime/('omarchy-pangolin-'+str(os.getuid())+'.lock')).open('a') as lock:
        try:
            fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        except BlockingIOError:
            raise UserError('A connection action is already running.')
        current = status()
        if current['running'] is None:
            raise UserError('Wait until the local client status is available.')
        if mode=='disconnect':
            if current['running']:
                local('POST','/exit')
                for _ in range(20):
                    if status()['running'] is False:
                        return
                    time.sleep(.5)
                raise UserError('Disconnect requested but not confirmed yet.')
        elif current['running'] is False:
            cli = shutil.which('pangolin')
            if not cli:
                raise UserError('Install the Pangolin CLI first.')
            a = account()
            # CLI handles its own privilege prompt in the user terminal.
            if subprocess.run([cli,'up','--silent','--endpoint',a['host'],'--org',a['org']],check=False).returncode:
                raise UserError('Pangolin could not connect. See the terminal output.')


def diagnose():
    a = account()
    try:
        with urllib.request.build_opener(NoRedirect()).open(a['host'],timeout=4) as r:
            message = 'Server HTTPS responds (HTTP '+str(r.status)+'). '+status()['label']
    except urllib.error.HTTPError as e:
        message = 'Server HTTPS responds (HTTP '+str(e.code)+'). '+status()['label']
    except OSError:
        message = 'Server HTTPS could not be reached. '+status()['label']
    notify(message)
    return dict(message=message)


def demo_status():
    return dict(state='connected',label='Connected · demo',running=True,registered=True,websocket=True,
                peerCount=1,peerTotal=1,tunnelIp='192.0.2.10',dns='192.0.2.1',detail='Synthetic preview. No network access.',peers=[])


def demo_resources():
    data = [('public:1','Documents','https://files.example.com',False),('public:2','Dashboard','https://dashboard.example.com',False),
            ('public:3','Notes','https://notes.example.com',False),('public:4','Photos','https://photos.example.com',False),
            ('site:1','Wiki','http://wiki.internal:8080/',True),('site:2','Metrics','http://metrics.internal:3000/',True)]
    return [dict(id=i,name=n,url=u,address=urlsplit(u).hostname,internal=p,enabled=True,site='Demo Site',siteOnline=True,ports='',mode='http',desktop=None,appInstalled=False) for i,n,u,p in data]


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--demo',action='store_true')
    parser.add_argument('command',choices=['status','resources','connect','disconnect','open','install','dashboard','diagnose','settings'])
    parser.add_argument('id',nargs='?')
    args=parser.parse_args()
    try:
        if args.demo:
            if args.command=='status': result=demo_status()
            elif args.command=='resources': result=dict(items=demo_resources(),error='')
            else: raise UserError('Actions are disabled in demo mode.')
        elif args.command=='status': result=status()
        elif args.command=='resources': result=dict(items=resources(),error='')
        elif args.command in ('connect','disconnect'):
            action(args.command); result=status(); notify(result['label'])
        elif args.command=='diagnose': result=diagnose()
        elif args.command=='settings':
            if not CONFIG.exists():
                CONFIG.parent.mkdir(parents=True,exist_ok=True)
                CONFIG.write_text(json.dumps({'schemaVersion':1,'accounts':{}},indent=2)+'\n')
            subprocess.run(['xdg-open',str(CONFIG)],check=True); result={}
        elif args.command=='dashboard':
            subprocess.run(['xdg-open',account()['host']],check=True); result={}
        else:
            from webapps import command, install
            if args.command=='install': install(args.id,loader=resources)
            else:
                item=next((r for r in resources() if r['id']==args.id),None)
                if not item or not item['enabled'] or not item['url']:
                    raise UserError('No enabled web resource with this ID.')
                if subprocess.run(command(item),check=False).returncode:
                    raise UserError('Could not open the resource.')
            result={}
        print(json.dumps(result,ensure_ascii=False))
        return 0
    except Exception as e:
        message=str(e) if isinstance(e,UserError) else 'Operation failed. Check configuration, dependencies and server compatibility.'
        print(json.dumps(dict(items=[],error=message),ensure_ascii=False))
        if args.command not in ('status','resources'): notify(message)
        return 1


if __name__=='__main__':
    sys.exit(main())
