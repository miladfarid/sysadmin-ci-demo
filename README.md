# sysadmin-ci-demo

„Ich möchte vor jeder Bereitstellung automatisch prüfen, ob Änderungen an der Webserver-Konfigurationsdatei vorgenommen wurden, um menschliche Fehler zu vermeiden.“
„Ziel ist es, die Konfigurationsvalidierung mithilfe von CI/CD zu einem obligatorischen und automatisierten Schritt im Entwicklungsprozess zu machen.“

## CI/CD in diesem Repository

### Manuelle Schritte ohne Automatisierung
Bei jeder Änderung an der `config/webserver.conf` müsste ich ohne CI/CD diese 3 Schritte manuell machen:

1. Die Datei `config/webserver.conf` auf Existenz prüfen
2. Die Datei auf leeren Inhalt prüfen
3. Prüfen, ob wichtige Schlüsselwörter wie `server`, `listen` oder `port` enthalten sind

### Was ist CI und wo beginnt CD?
- **CI (Continuous Integration)**: Das automatische Prüfen der Konfigurationsdatei bei jedem `push` in den `main`-Branch. Das habe ich mit GitHub Actions umgesetzt.
- **CD (Continuous Delivery)**: Würde hier beginnen, wenn nach erfolgreicher Prüfung die Konfiguration automatisch auf einen echten Webserver deployt wird.

### 3 Vorteile von CI/CD für dieses Szenario
1. **Fehlervermeidung**: Menschliche Fehler bei der manuellen Prüfung werden ausgeschlossen
2. **Zeitersparnis**: Die Prüfung läuft automatisch und ich muss nicht jedes Mal manuell testen
3. **Schnelles Feedback**: Ich sehe sofort nach einem `push`, ob die Konfiguration gültig ist

### 3 Best Practices in diesem Repository
1. **Kleine Änderungen**: Ich committe nur kleine, logische Änderungen
2. **Klare Commit-Nachrichten**: Jede Commit-Nachricht beschreibt genau, was geändert wurde
3. **Schnelle Prüfungen**: Das Skript läuft in wenigen Sekunden durch und gibt sofort Feedback

## Testergebnisse

### Erfolgreicher Run (26.06.2026)
- **Auslöser**: `push` auf `main` nach Hinzufügen eines Kommentars
- **Ergebnis**: ✅ Erfolgreich
- **Betroffene Steps**: Alle Steps erfolgreich durchgelaufen
- **Notiz**: Die Konfiguration war gültig, daher hat der Workflow grün geliefert.

### Fehlgeschlagener Run (26.06.2026)
- **Auslöser**: `push` auf `main` nach dem Leeren der Konfigurationsdatei
- **Ergebnis**: ❌ Fehlgeschlagen
- **Betroffener Step**: `config/webserver.conf prüfen`
- **Korrektur**: Die Konfigurationsdatei wurde wieder mit gültigem Inhalt gefüllt und der Workflow lief anschließend erfolgreich durch.
