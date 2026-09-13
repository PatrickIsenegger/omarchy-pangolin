# Bedienungsanleitung

[Hilfe-Startseite](README.md) · [English](guide.md)

## Symbole und Ressourcen

| Symbol | Bedeutung | Linksklick |
| --- | --- | --- |
| Fenster mit Häkchen | Bereits installierte Web-App; dezent getönte Kachel | Öffnet das App-Fenster |
| Globus | Web-Ressource ohne erkannten App-Launcher | Öffnet die URL im Browser |
| Überlappende Blätter | Host-Adresse ohne konfigurierte Web-URL | Kopiert die Adresse |
| ⋮ | Aktionen zur Ressource | Öffnet das Menü |

Die Symbole ersetzen die wiederholten App-/Web-Textzeilen. Öffentliche und private Ressourcen bleiben getrennt; private Zeilen sind etwas kleiner. Lange Namen werden gekürzt. Hover oder Tastaturfokus zeigt den vollständigen Namen, das Ziel und die Voraussetzungen.

Im **⋮-Menü** kannst du öffnen, die URL kopieren oder eine Web-App installieren. Rechtsklick auf eine aktive Ressource öffnet dasselbe Menü. Bei installierten Apps entfällt die Installation. „Install as app“ erstellt einen lokalen Omarchy-Launcher; der Dienst bleibt auf seinem Server. Aktualisieren prüft die Ressource und den erkannten App-Status erneut.

## Verbindung und Farben

- **Grün:** Der lokale Pangolin-Client bestätigt die Verbindung. Einzelne Sites können trotzdem erst bei Bedarf verbunden werden.
- **Orange:** Registrierung ausstehend, Warnung oder unbekannter/veralteter Status. Details prüfen.
- **Rot:** Getrennt oder Client-Fehler. Die Beschriftung unterscheidet beide Fälle.

Die Statusfarben gelten für die Punkte; Icon und Kopfbereich folgen dem Theme-Akzent. Fehlende Statusfarben werden mit passender Helligkeit und Sättigung abgeleitet. Die Verbindungsanimation läuft nur bei bestätigter Verbindung und geöffnetem Panel. Ressourcen-Symbole reagieren kurz auf Hover; es gibt keine externen Icon-Downloads.

**Connect** startet Pangolin in einem Terminal für nötige Anmeldung oder Berechtigungen. **Disconnect** beendet die Verbindung. Interne Ressourcen benötigen die Verbindung und funktionierendes Alias-DNS. Eine Host-Adresse ist nicht automatisch eine HTTP(S)-URL: siehe [Konfiguration](configuration.md).

## Weitere Bedienelemente

- Linksklick auf das Leisten-Symbol öffnet das Panel; Rechtsklick öffnet das Dashboard des aktiven Kontos.
- **↻** lädt Ressourcen und App-Erkennung neu. **All / Less** blendet über die ersten acht hinaus weitere öffentliche Ressourcen ein oder aus.
- **Details** zeigt Tunnel, DNS, Sites und Statusdetails; dort findest du HTTPS-Diagnose und Server-Dashboard.
- **⚙** öffnet lokale Einstellungen. Diese liegen außerhalb des Plugin-Checkouts.
- **Restart shell** startet die gesamte Omarchy-Shell einschließlich anderer Plugins neu, lässt aber die VPN-Verbindung bestehen.
- **? Help** öffnet die öffentliche Dokumentation ohne private Daten im Link.

Mit Tab durch die Schaltflächen navigieren, mit Enter/Leertaste aktivieren. Escape schließt zunächst ein geöffnetes Menü beziehungsweise das Panel. Auch nicht verfügbare Aktionen bleiben mit der Maus erklärbar. Im Demo-Modus bleiben echte Aktionen deaktiviert.

## Hilfe bei Problemen

Bei gekürzten Namen oder unklaren Zielen zuerst den Hover-Hinweis prüfen. Wenn eine App fehlt, Ressourcen aktualisieren. Bei internen Verbindungsproblemen Status, DNS und konfigurierte URL prüfen. Weitere Schritte: [Fehlerbehebung](troubleshooting.md).

Bitte nur erfundene Ressourcen und bereinigte Fehlermeldungen in GitHub-Issues verwenden; keine Zugangsdaten, privaten URLs oder Kontodateien veröffentlichen.

## Panel command

```bash
omarchy-shell shell toggle community.pangolin
```

Öffnet oder schließt das aktivierte Plugin, ohne die Verbindung zu ändern. Geeignet für Terminal und Tastenkombinationen. Bei „not running“ die Omarchy-Shell starten; bei unbekannter Kennung Installation und Aktivierung prüfen.
