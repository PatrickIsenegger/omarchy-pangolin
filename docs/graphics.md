# Graphics

`assets/preview.png` compares dark and light synthetic palettes. `assets/usage.png` labels the controls. `assets/social-preview.png` is a 1280 × 640 repository sharing image.

The actual `Dashboard.qml` is rendered in an offscreen Qt window by `tools/Preview.qml`. `tools/preview-imports` supplies tiny, original Color/Style adapters so the demo does not load a desktop session, account or network. Production imports the installed Omarchy modules instead. Demo controls are non-interactive.

To render the dark demo from the repository root (Qt 6 tools required):

```bash
QT_QPA_PLATFORM=offscreen QT_QPA_PLATFORMTHEME=generic QT_QUICK_CONTROLS_STYLE=Basic QT_QUICK_BACKEND=software qmlscene -I tools/preview-imports tools/Preview.qml
```

Set `light: true` in the preview harness for the light variant, then restore it. Fixed demonstration palette colors belong only in preview assets/tools; production QML uses the active theme.

A short walkthrough recording can be added after real-world beta testing. Never record an authenticated account for publication.
