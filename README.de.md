# Pangolin für Omarchy

Community-Plugin für Verbindungen, öffentliche und private Ressourcen sowie Web-Apps. Die Oberfläche übernimmt das aktive Omarchy-Theme. **Version 0.1.0-beta.1**, Oberfläche zunächst Englisch.

![Theme-Vorschau mit erfundenen Ressourcen](assets/preview.png)

Unabhängiges Community-Projekt. Sämtliche Beispiele und Vorschauen sind synthetisch.

## Installation

```bash
omarchy plugin add https://github.com/PatrickIsenegger/omarchy-pangolin.git --enable
```

Pangolin-CLI installieren, mit `pangolin login` anmelden und eine Organisation auswählen. Das Plugin verwendet das aktive CLI-Konto. Eine bereits vorhandene Installation mit derselben ID vor einer Migration sichern.

## Bedienung

Linksklick öffnet das Panel, Rechtsklick das Dashboard. Ressourcen öffnen im Browser oder in einer erkannten Web-App. Das Plus installiert einen Launcher; der Kopierknopf kopiert die Adresse. Interne Ressourcen benötigen Pangolin und Alias-DNS. Für Host-Webdienste die vollständige URL oder ein bekanntes Protokoll in der Konfiguration hinterlegen.

„Restart shell“ startet die gesamte Omarchy-Leiste mit ihren Plugins neu; die VPN-Verbindung bleibt bestehen. Ohne bestätigte Verbindung gibt es keine Statusanimation.

Der Zahnradknopf öffnet die lokale Konfiguration außerhalb des Git-Checkouts. Zugangsdaten gehören dort nicht hinein. Der Demo-Modus verwendet erfundene Daten, greift nicht auf Konten zu und deaktiviert Aktionen.

```bash
omarchy plugin update patrick.pangolin
omarchy plugin remove patrick.pangolin
```

Updates folgen dem Standardbranch. Lokale Einstellungen und installierte Web-Apps bleiben beim Entfernen bestehen. Weitere Angaben zu Abhängigkeiten, Datenzugriff, Tests und Konfiguration stehen in der [englischen README](README.md).
