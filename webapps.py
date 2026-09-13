#!/usr/bin/env python3
"""Launch configured web resources via installed desktop apps or Chromium."""
import configparser
import fcntl
import json
from pathlib import Path
import shlex
import subprocess
import sys
from urllib.parse import urlsplit

APP_DIRS = [Path.home()/".local/share/applications", Path("/usr/local/share/applications"), Path("/usr/share/applications")]


def installed_apps():
    apps = {}
    for directory in APP_DIRS:
        for path in sorted(directory.glob("*.desktop")):
            if path.name in apps:
                continue
            parser = configparser.ConfigParser(interpolation=None, strict=False)
            try:
                parser.read(path)
                entry = parser["Desktop Entry"]
                apps[path.name] = None
                if entry.get("Hidden", "false").lower() == "true" or entry.get("Type") != "Application":
                    continue
                args = shlex.split(entry.get("Exec", ""))
                urls = [arg.removeprefix("--app=").rstrip("/") for arg in args if arg.startswith(("https://", "http://", "--app=https://", "--app=http://"))]
                apps[path.name] = urls
            except (OSError, ValueError, KeyError, configparser.Error):
                continue
    return apps


def command(item):
    return ["gtk-launch", item["desktop"]] if item["desktop"] else ["chromium", "--new-tab", item["url"]]


def install(resource_id, loader):
    lock_path = Path.home()/".cache/omarchy/pangolin-app-install.lock"
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        item = next(item for item in loader() if item["id"] == resource_id)
        parsed = urlsplit(item.get("url") or "")
        if parsed.scheme not in ("http", "https") or not parsed.hostname or parsed.username or parsed.password or item.get("enabled") is False:
            raise ValueError("This resource cannot be installed as a web app")
        if item["appInstalled"]:
            return
        name = str(item["name"]).strip()
        if not name or "/" in name or "\\" in name or any(ord(c) < 32 for c in name):
            raise ValueError("Invalid app name")
        # Never overwrite a different existing launcher with the same name.
        candidate = name
        number = 1
        while any((directory/(candidate + ".desktop")).exists() or (directory/(candidate + ".desktop")).is_symlink() for directory in APP_DIRS):
            candidate = name + " (Pangolin" + (" " + str(number) if number > 1 else "") + ")"
            number += 1
        subprocess.run(["omarchy", "webapp", "install", candidate, item["url"], "applications-internet"], check=True, timeout=20)
        if not any(urls is not None and item["url"].rstrip("/") in urls for urls in installed_apps().values()):
            raise RuntimeError("Could not verify the installed app")
        subprocess.run(["notify-send", "Pangolin", name + " is now available as an app"], check=False)


