[![Pangolin für Omarchy – Aquarell-Titelbild](assets/readme-hero.png)](https://patrickisenegger.com)

# Pangolin für Omarchy

Community-Plugin für Verbindungen, öffentliche und private Ressourcen sowie Web-Apps. Die Oberfläche übernimmt das aktive Omarchy-Theme. **Community-Beta**, Oberfläche zunächst Englisch.

[![Version](assets/badges/version.svg)](https://github.com/PatrickIsenegger/omarchy-pangolin/releases)
[![Lizenz](assets/badges/license.svg)](LICENSE)
[![Hosting](assets/badges/hosting.svg)](docs/compatibility.md)

![Theme-Vorschau mit erfundenen Ressourcen](assets/preview.png)

Feine SVG-Farbflächen und ein atmendes Symbol beleben das Panel nur bei bestätigter Verbindung. Die Aquarell-Optik ist von [meiner Webseite](https://patrickisenegger.com) inspiriert; die Farben der Oberfläche folgen deinem Omarchy-Theme.

Unabhängiges Community-Projekt. Sämtliche Beispiele und Vorschauen sind synthetisch.

## Installation

```bash
omarchy plugin add https://github.com/PatrickIsenegger/omarchy-pangolin.git --enable
```

Pangolin-CLI installieren. Für Pangolin Cloud mit `pangolin login app.pangolin.net`, für Self-Hosting mit `pangolin login https://gateway.example.com` anmelden und eine Organisation auswählen. Beide Varianten werden über das aktive CLI-Konto unterstützt. Cloud ist mit synthetischen Tests abgedeckt; ein echter Cloud-End-to-End-Test steht noch aus. Das Plugin verwendet das aktive CLI-Konto. Eine bereits vorhandene Installation mit derselben ID vor einer Migration sichern.

## Bedienung

Die kompakte Ressourcenliste zeigt nur Symbol und Name: Fenster mit Häkchen = installierte App, Globus = Browser-Link, überlappende Blätter = Host-Adresse kopieren. Apps erhalten eine dezente, flache Tönung. Hover-Infos erklären Ziel und Voraussetzungen.

Linksklick öffnet die Ressource. Das **⋮-Menü** (auch per Rechtsklick) enthält Kopieren und App-Installation. **? Help** im Panel führt zur [Dokumentation](docs/README.md). Interne Dienste benötigen die Pangolin-Verbindung und Alias-DNS; für Host-Webdienste gegebenenfalls eine vollständige URL konfigurieren.

Oben steht Grün für verbunden, Gelb für ausstehend/unbekannt oder Warnung und Rot für getrennt/Fehler – jeweils aus dem Theme.

„Restart shell“ startet die gesamte Omarchy-Leiste mit ihren Plugins neu; die VPN-Verbindung bleibt bestehen. Ohne bestätigte Verbindung gibt es keine Statusanimation.

Der Zahnradknopf öffnet die lokale Konfiguration außerhalb des Git-Checkouts. Zugangsdaten gehören dort nicht hinein. Der Demo-Modus verwendet erfundene Daten, greift nicht auf Konten zu und deaktiviert Aktionen.

```bash
omarchy plugin update patrick.pangolin
omarchy plugin remove patrick.pangolin
```

Updates folgen dem Standardbranch. Lokale Einstellungen und installierte Web-Apps bleiben beim Entfernen bestehen. Weitere Angaben zu Abhängigkeiten, Datenzugriff, Tests und Konfiguration stehen in der [englischen README](README.md).

Entwickelt von [Patrick Isenegger](https://patrickisenegger.com) · [Änderungen](CHANGELOG.md) · [Versionierung](docs/releases.md)
