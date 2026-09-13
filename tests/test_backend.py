import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import backend as b
import webapps as w


class BackendTests(unittest.TestCase):
    def row(self, **kw):
        return dict(dict(launcherResourceKey='site:1',name='Wiki',resourceType='site',mode='host',accessCopyValue='wiki.internal',enabled=True),**kw)

    def test_cloud_and_self_hosted_accounts(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)/'accounts.json'
            for host, expected in [('app.pangolin.net', 'https://app.pangolin.net'), ('https://app.pangolin.net/', 'https://app.pangolin.net'), ('https://gateway.example.com/api/v1', 'https://gateway.example.com')]:
                path.write_text(json.dumps({'activeuserid':'demo', 'accounts':{'demo':{'host':host, 'orgId':'demo-org', 'sessionToken':'synthetic-session'}}}))
                with patch.object(b, 'ACCOUNTS', path):
                    self.assertEqual(b.account(), {'host':expected, 'org':'demo-org', 'token':'synthetic-session'})

    def test_malformed_account_types_are_user_errors(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)/'accounts.json'
            path.write_text(json.dumps({'activeuserid':'demo', 'accounts':{'demo':{
                'host': ['https://app.pangolin.net'], 'orgId':'demo-org',
                'sessionToken':'synthetic-session'}}}))
            with patch.object(b, 'ACCOUNTS', path):
                with self.assertRaises(b.UserError):
                    b.account()

    def test_api_uses_selected_control_plane(self):
        for host in ['https://app.pangolin.net', 'https://gateway.example.com']:
            from unittest.mock import MagicMock
            import io
            opener = MagicMock()
            opener.open.return_value.__enter__.return_value = io.BytesIO(b'{"success":true,"data":{"resources":[]}}')
            with patch.object(b.urllib.request, 'build_opener', return_value=opener):
                self.assertEqual(b.api({'host':host,'org':'demo-org','token':'synthetic-session'}, '/launcher/resources'), {'resources':[]})
            request = opener.open.call_args.args[0]
            self.assertEqual(request.full_url, host+'/api/v1/org/demo-org/launcher/resources')
            self.assertEqual(request.get_header('Cookie'), 'p_session_token=synthetic-session')

    def test_malformed_api_envelopes_are_user_errors(self):
        from unittest.mock import MagicMock
        import io
        for payload in [b'[]', b'{"success":true,"data":[]}']:
            opener = MagicMock()
            opener.open.return_value.__enter__.return_value = io.BytesIO(payload)
            with patch.object(b.urllib.request, 'build_opener', return_value=opener):
                with self.assertRaises(b.UserError):
                    b.api({'host':'https://app.pangolin.net','org':'demo-org','token':'synthetic-session'}, '/launcher/resources')

    def test_status_semantics(self):
        d=dict(connected=True,registered=True,terminated=False,peers={})
        self.assertEqual(b.classify(d)['state'],'warning')
        d['peers']={'a':{'connected':True}}
        self.assertEqual(b.classify(d)['state'],'connected')
        self.assertEqual(b.classify(dict(d,registered=False))['state'],'warning')
        self.assertEqual(b.classify(dict(d,terminated=True))['state'],'off')
        with self.assertRaises(ValueError): b.classify({})

    def test_permission_is_not_disconnected(self):
        with patch.object(b,'local',side_effect=PermissionError()):
            self.assertIsNone(b.status()['running'])

    def test_url_validation(self):
        for value in ['javascript:alert(1)','https://u:p@example.com','http://example.com:99999','https://example.com/a\nb',None]:
            self.assertEqual(b.web_url(value),'')
        self.assertEqual(b.web_url('http://[2001:db8::1]:8080/'),'http://[2001:db8::1]:8080/')

    def test_no_protocol_guess(self):
        self.assertEqual(b.normalize(self.row(),{'tcpPortRangeString':'8080'},{},{})['url'],'')
        config={'hostSchemes':{'wiki.internal':'http'}}
        self.assertEqual(b.normalize(self.row(),{'tcpPortRangeString':'8080'},config,{})['url'],'http://wiki.internal:8080/')
        for port in ['80,443','0','65536','8000-8010']:
            self.assertEqual(b.normalize(self.row(),{'tcpPortRangeString':port},config,{})['url'],'')

    def test_cidr_not_browser(self):
        self.assertEqual(b.normalize(self.row(mode='cidr'),{'tcpPortRangeString':'80'},{'hostSchemes':{'wiki.internal':'http'}},{})['url'],'')

    def test_explicit_url_and_app_match(self):
        config={'webUrls':{'site:1':'https://wiki.internal:8443/'}}
        r=b.normalize(self.row(),None,config,{'Wiki.desktop':['https://wiki.internal:8443']})
        self.assertTrue(r['appInstalled'])
        self.assertEqual(r['desktop'],'Wiki.desktop')

    def test_optional_admin_metadata_and_account_scope(self):
        def pages(*args):
            if args[1]=='/site-resources': raise b.UserError('Access denied')
            return [self.row()]
        with patch.object(b,'account',return_value={'host':'https://gateway.example.com','org':'demo'}),patch.object(b,'pages',side_effect=pages),patch.object(b,'settings',return_value={'accounts':{'https://other.example.com':{'demo':{'webUrls':{'site:1':'https://wrong.example.com'}}}}}),patch.object(w,'installed_apps',return_value={}):
            self.assertEqual(b.resources()[0]['url'],'')

    def test_pagination(self):
        with patch.object(b,'api',side_effect=[{'resources':[1],'pagination':{'total':101}},{'resources':[2],'pagination':{'total':101}}]):
            self.assertEqual(b.pages({},'/launcher/resources','resources'),[1,2])

    def test_no_redirect(self):
        self.assertIsNone(b.NoRedirect().redirect_request(None,None,302,'',{},'https://other.example.com'))

    def test_install_preserves_existing_launcher(self):
        with tempfile.TemporaryDirectory() as temp:
            path=Path(temp)
            (path/'Wiki.desktop').write_text('[Desktop Entry]\nType=Application\nExec=chromium --app=https://wiki.example.com\n')
            item=dict(id='site:1',name='Wiki',url='http://wiki.internal:8080/',enabled=True,appInstalled=False)
            calls=[]
            def run(args,**kwargs):
                calls.append(args)
                if args[:3]==['omarchy','webapp','install']:
                    (path/(args[3]+'.desktop')).write_text('[Desktop Entry]\nType=Application\nExec=chromium --app='+args[4]+'\n')
            with patch.object(w,'APP_DIRS',[path]),patch.object(w.subprocess,'run',side_effect=run),patch.object(w.Path,'home',return_value=path):
                w.install('site:1',loader=lambda:[item])
                self.assertEqual(calls[0][3],'Wiki (Pangolin)')
                self.assertIn('https://wiki.example.com',(path/'Wiki.desktop').read_text())
                with self.assertRaises(ValueError): w.install('site:1',loader=lambda:[dict(item,enabled=False)])

    def test_demo_does_not_read_accounts(self):
        with patch.object(b,'account',side_effect=AssertionError('No account access')):
            self.assertTrue(b.demo_resources())
            self.assertEqual(b.demo_status()['state'],'connected')


if __name__=='__main__': unittest.main()
