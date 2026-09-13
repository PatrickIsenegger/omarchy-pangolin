<p align="center">
  <a href="https://patrickisenegger.com"><img src="assets/readme-hero.png" alt="Pangolin für Omarchy – Aquarell-Titelbild" width="100%"></a>
</p>

# Pangolin für Omarchy

Community-Plugin für Verbindungen, öffentliche und private Ressourcen sowie Web-Apps. Die Oberfläche übernimmt das aktive Omarchy-Theme. **Community-Release**, Oberfläche zunächst Englisch.

<p align="center">
  <a href="https://github.com/PatrickIsenegger/omarchy-pangolin/releases/latest"><img src="assets/badges/release.svg" alt="Release: 0.1.0"></a>
  <a href="LICENSE"><img src="assets/badges/license.svg" alt="Lizenz: MIT"></a>
  <a href="docs/compatibility.md"><img src="assets/badges/hosting.svg" alt="Hosting: Cloud und Self-Hosting"></a>
  <a href="docs/graphics.md"><img src="assets/badges/theme.svg" alt="Stil: Omarchy-Theme"></a>
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="docs/README.md">Dokumentation</a> ·
  <a href="docs/configuration.md">Konfiguration</a> ·
  <a href="https://github.com/PatrickIsenegger/omarchy-pangolin/releases/latest">Aktuelles Release</a>
</p>

![Theme-Vorschau mit erfundenen Ressourcen](assets/preview.png)

Feine SVG-Farbflächen und ein atmendes Symbol beleben das Panel nur bei bestätigter Verbindung. Die Farben der Oberfläche folgen deinem Omarchy-Theme. [Artwork und Rendering](docs/graphics.md).

Unabhängiges Community-Projekt. Sämtliche Beispiele und Vorschauen sind synthetisch.

## Installation

Der Plugin-Befehl installiert keine Pangolin-CLI und keine Systempakete automatisch. Die [Voraussetzungen und Installationsschritte](docs/requirements.md) zeigen, was Omarchy mitbringt, welche Pakete gegebenenfalls fehlen und wie die CLI eingerichtet wird.

```bash
omarchy plugin add https://github.com/PatrickIsenegger/omarchy-pangolin.git --enable
```

Pangolin-CLI installieren. Für Pangolin Cloud mit `pangolin login app.pangolin.net`, für Self-Hosting mit `pangolin login https://gateway.example.com` anmelden und eine Organisation auswählen. Beide Varianten werden über das aktive CLI-Konto unterstützt. Cloud ist mit synthetischen Tests abgedeckt; ein echter Cloud-End-to-End-Test steht noch aus. Das Plugin verwendet das aktive CLI-Konto. Eine bereits vorhandene Installation mit derselben ID vor einer Migration sichern.

Eine bestehende Installation mit der alten Kennung wird über die [einmalige Migration](docs/migration.md) umgestellt; Position und Einstellungen bleiben erhalten.

## Bedienung

Die kompakte Ressourcenliste zeigt nur Symbol und Name: Fenster mit Häkchen = installierte App, Globus = Browser-Link, überlappende Blätter = Host-Adresse kopieren. Apps erhalten eine dezente, flache Tönung. Hover-Infos erklären Ziel und Voraussetzungen.

Linksklick öffnet die Ressource. Das **⋮-Menü** (auch per Rechtsklick) enthält Kopieren und App-Installation. **? Help** im Panel führt zur [Dokumentation](docs/README.md). Interne Dienste benötigen die Pangolin-Verbindung und Alias-DNS; für Host-Webdienste gegebenenfalls eine vollständige URL konfigurieren.

Icon und Kopfbereich folgen der Theme-Akzentfarbe. Der Statuspunkt zeigt Grün für verbunden, Orange für ausstehend/unbekannt oder Warnung und Rot für getrennt/Fehler. Fehlende Statusfarben werden passend zur Helligkeit und Sättigung des Themes abgeleitet.

„Restart shell“ startet die gesamte Omarchy-Leiste mit ihren Plugins neu; die VPN-Verbindung bleibt bestehen. Die Statusanimation läuft nur bei bestätigter Verbindung und geöffnetem Panel. Ressourcen-Symbole reagieren mit einer kurzen Bewegung auf Hover.

Der Zahnradknopf öffnet die lokale Konfiguration außerhalb des Git-Checkouts. Zugangsdaten gehören dort nicht hinein. Der Demo-Modus verwendet erfundene Daten, greift nicht auf Konten zu und deaktiviert Aktionen.

```bash
omarchy plugin update community.pangolin
omarchy plugin remove community.pangolin
```

Updates folgen dem Standardbranch. Lokale Einstellungen und installierte Web-Apps bleiben beim Entfernen bestehen. Weitere Angaben zu Abhängigkeiten, Datenzugriff, Tests und Konfiguration stehen in der [englischen README](README.md).

Entwickelt von [Patrick Isenegger](https://patrickisenegger.com) · [Änderungen](CHANGELOG.md) · [Versionierung](docs/releases.md)
