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

## Erweiterungsaufgabe 1: Pull-Request-Trigger

### Warum ist ein `pull_request`-Trigger in einem Team sinnvoll?

In einem Team arbeiten mehrere Entwickler gleichzeitig an verschiedenen Features. Wenn jemand eine Änderung vorschlägt (über einen Pull Request), muss sichergestellt sein, dass diese Änderung nichts kaputt macht.

**Vorteile des Pull-Request-Triggers:**
1. **Automatische Prüfung vor dem Merge**: Jeder Pull Request wird automatisch geprüft, bevor er in `main` gemergt wird
2. **Qualitätssicherung**: Fehler werden entdeckt, bevor sie in den Hauptbranch gelangen
3. **Code-Review**: Zusammen mit dem Code-Review gibt es zusätzliche Sicherheit durch automatisierte Tests

**Getestet am 26.06.2026:**
- Branch `feature/update-config` erstellt
- Änderung in `config/webserver.conf` vorgenommen
- Pull Request auf `main` geöffnet
- Workflow wurde automatisch gestartet und war ✅ erfolgreich

## Erweiterungsaufgabe 2: Zweiten Job einbauen

### Was wurde gemacht?

Dem Workflow wurde ein zweiter Job (`deploy-notification`) hinzugefügt, der **nur nach erfolgreicher Konfigurationsprüfung** läuft.

### Wie funktioniert die Verknüpfung?

- **`needs: validate-config`**: Sagt GitHub Actions, dass dieser Job erst nach `validate-config` starten darf
- **`if: success()`**: Sagt GitHub Actions, dass dieser Job nur läuft, wenn der vorherige Job erfolgreich war

### Warum ist das sinnvoll?

In einem echten CI/CD-Szenario könnte der zweite Job:
- Die Konfiguration auf einen Test-Server deployen
- Eine E-Mail-Benachrichtigung an das Team senden
- Einen Produktions-Deployment starten
- Einen Slack- oder Teams-Webhook aufrufen

**Getestet am 26.06.2026:**
- Beide Jobs wurden erfolgreich ausgeführt
- Der zweite Job wurde nur nach erfolgreichem ersten Job gestartet
- Die Abhängigkeit zwischen den Jobs funktioniert wie erwartet


## Erweiterungsaufgabe 3: Prüfung erweitert

### Was wurde erweitert?

Das Skript `scripts/check-config.sh` wurde um folgende Prüfungen erweitert:

1. **Platzhalter-Check**: Die Datei wird auf `TODO` und `FIXME` untersucht. Wenn solche Platzhalter gefunden werden, schlägt die Prüfung fehl.
2. **Backup-Check**: Eine optionale Backup-Datei (`config/backup.conf`) wird auf Existenz und Inhalt geprüft.

### Warum ist das sinnvoll?

- **Platzhalter-Check**: Verhindert, dass unvollständige Konfigurationen deployt werden
- **Backup-Check**: Stellt sicher, dass im Notfall eine Backup-Konfiguration verfügbar ist

### Getestet am 26.06.2026

| Testfall | Ergebnis |
| :--- | :--- |
| Konfiguration ohne TODO/FIXME | ✅ Erfolg |
| Konfiguration mit TODO | ❌ Fehler (Platzhalter gefunden) |
| Konfiguration mit Backup-Datei | ℹ️ Info (Backup gefunden) |

### Nächste mögliche Erweiterungen

- Prüfung auf doppelte Zeilen
- Validierung von Pfaden (z.B. `/var/www/html` muss existieren)
- Prüfung von Berechtigungen (z.B. `chmod` der Datei)

## Reflexionsfragen

### 1. Welche manuellen Prüfungen wurden automatisiert?
Ich habe die Prüfung auf Existenz, Inhalt, Schlüsselwörter und Platzhalter automatisiert. Alle diese Schritte muss ich jetzt nicht mehr manuell machen.

### 2. Welcher Trigger ist am besten?
Für mein Szenario ist `push` am besten, weil ich sofort nach jedem Commit Feedback bekomme. Für Teams ist `pull_request` auch sehr wichtig.

### 3. Was ist CI und wo beginnt CD?
CI ist die automatische Prüfung der Konfiguration. CD würde mit dem automatischen Deployment auf einen echten Server beginnen.

### 4. Wichtigste Best Practice
Kleine, nachvollziehbare Änderungen mit klaren Commit-Nachrichten waren für mich am wichtigsten.

### 5. Nächste Automatisierungsschritte
Als Nächstes würde ich den echten Deploy auf einen Server automatisieren, gefolgt von Tests nach dem Deploy und automatischen Benachrichtigungen.
