# Prozessdokumentation: CI/CD-Grundlagen mit GitHub Actions

## 1. Übersicht

Dieses Dokument beschreibt den gesamten Prozess der Erstellung einer CI-Pipeline für ein SysAdmin-Szenario mit GitHub Actions.

**Ziel:** Automatische Prüfung einer Webserver-Konfigurationsdatei (`config/webserver.conf`) bei jedem Push und Pull Request.

---

## 2. Vorbereitung (Aufgabe 1)

### 2.1 Repository erstellen

```bash
# Repository auf GitHub erstellt: https://github.com/miladfarid/sysadmin-ci-demo
# Repository lokal klonen
git clone https://github.com/miladfarid/sysadmin-ci-demo.git
cd sysadmin-ci-demo
```

### 2.2 Ordnerstruktur anlegen

```bash
mkdir -p config scripts
```

### 2.3 Dateien erstellen

**config/webserver.conf:**
```nginx
# Eine einfache Webserver-Konfiguration
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
}
```

**scripts/check-config.sh:**
```bash
#!/bin/bash
# (später gefüllt)
```

**README.md:**
```markdown
# sysadmin-ci-demo

"Ich möchte vor jeder Bereitstellung automatisch prüfen, ob Änderungen an der Webserver-Konfigurationsdatei vorgenommen wurden, um menschliche Fehler zu vermeiden."
"Ziel ist es, die Konfigurationsvalidierung mithilfe von CI/CD zu einem obligatorischen und automatisierten Schritt im Entwicklungsprozess zu machen."
```

### 2.4 Erster Commit

```bash
git add .
git commit -m "Initialer Commit: Grundstruktur und Beispiel-Konfiguration"
git push origin main
```

**✅ Ergebnis:** Repository mit klarer Ordnerstruktur, Beispiel-Konfiguration und README.

---

## 3. Lokales Prüfskript erstellen (Aufgabe 2)

### 3.1 Skript schreiben

**scripts/check-config.sh:**
```bash
#!/bin/bash

CONFIG_FILE="config/webserver.conf"

# 1. Existenz prüfen
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE existiert nicht."
    exit 1
fi

# 2. Leer prüfen
if [ ! -s "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE ist leer."
    exit 1
fi

# 3. Schlüsselwörter prüfen
if ! grep -q "server" "$CONFIG_FILE" && ! grep -q "listen" "$CONFIG_FILE" && ! grep -q "port" "$CONFIG_FILE"; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE enthält kein gültiges Schlüsselwort (server, listen oder port)."
    exit 1
fi

echo "✅ Erfolg: Die Konfigurationsdatei ist gültig."
exit 0
```

### 3.2 Skript ausführbar machen

```bash
chmod +x scripts/check-config.sh
```

### 3.3 Tests

**Test 1 - Erfolg:**
```bash
./scripts/check-config.sh
# Ausgabe: ✅ Erfolg: Die Konfigurationsdatei ist gültig.
```

**Test 2 - Fehler (Datei leeren):**
```bash
> config/webserver.conf
./scripts/check-config.sh
# Ausgabe: ❌ Fehler: Die Datei config/webserver.conf ist leer.
```

**Test 3 - Wiederherstellen:**
```bash
echo "server { listen 80; server_name localhost; }" > config/webserver.conf
./scripts/check-config.sh
# Ausgabe: ✅ Erfolg: Die Konfigurationsdatei ist gültig.
```

### 3.4 Commit

```bash
git add scripts/check-config.sh
git commit -m "Skript zur Konfigurationsprüfung hinzugefügt"
git push origin main
```

**✅ Ergebnis:** Das Skript prüft lokal erfolgreich und gibt bei Fehlern einen Fehlerstatus zurück.

---

## 4. CI/CD-Theorie auf Beispiel übertragen (Aufgabe 3)

### 4.1 README.md erweitert

Folgende Abschnitte wurden zur README.md hinzugefügt:

- **Manuelle Schritte ohne Automatisierung** (3 Schritte)
- **Was ist CI und wo beginnt CD?**
- **3 Vorteile von CI/CD für dieses Szenario**
- **3 Best Practices**

**Commit:**
```bash
git add README.md
git commit -m "README mit CI/CD-Erklärungen ergänzt"
git push origin main
```

**✅ Ergebnis:** README enthält konkreten Bezug zwischen CI/CD-Theorie und praktischem Beispiel.

---

## 5. GitHub-Workflow anlegen (Aufgabe 4)

### 5.1 Workflow-Datei erstellen

**Datei:** `.github/workflows/config-check.yml`

```yaml
name: Config-Datei prüfen

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  validate-config:
    runs-on: ubuntu-latest
    
    steps:
      - name: Repository auschecken
        uses: actions/checkout@v3
      
      - name: Dateiliste anzeigen
        run: |
          echo "📁 Verzeichnisstruktur:"
          ls -la
          echo "📄 config/ Verzeichnis:"
          ls -la config/ || echo "config/ existiert nicht"
      
      - name: Skript ausführbar machen
        run: chmod +x scripts/check-config.sh
      
      - name: config/webserver.conf prüfen
        run: ./scripts/check-config.sh
```

### 5.2 Commit

```bash
git add .github/workflows/config-check.yml
git commit -m "GitHub Actions Workflow für Konfigurationsprüfung hinzugefügt"
git push origin main
```

**✅ Ergebnis:** Workflow-Datei liegt im richtigen Ordner und wird im Actions-Tab erkannt.

---

## 6. Workflow testen und dokumentieren (Aufgabe 5)

### 6.1 Test 1 - Erfolg

**Änderung in config/webserver.conf:**
```nginx
# Meine Webserver-Konfiguration
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
}
```

**Commit und Push:**
```bash
git add config/webserver.conf
git commit -m "Kommentar zur Webserver-Konfiguration hinzugefügt"
git push origin main
```

**Ergebnis in GitHub Actions:**
- ✅ Alle Steps erfolgreich (grün)
- Workflow erfolgreich durchgelaufen

### 6.2 Test 2 - Fehler

**Konfiguration leeren:**
```bash
> config/webserver.conf
```

**Commit und Push:**
```bash
git add config/webserver.conf
git commit -m "TEST: Webserver-Konfiguration geleert (sollte Fehler verursachen)"
git push origin main
```

**Ergebnis in GitHub Actions:**
- ❌ Workflow fehlgeschlagen (rot)
- Betroffener Step: `config/webserver.conf prüfen`

### 6.3 Test 3 - Wiederherstellen

```bash
echo "# Meine Webserver-Konfiguration
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
}" > config/webserver.conf

git add config/webserver.conf
git commit -m "Webserver-Konfiguration wiederhergestellt"
git push origin main
```

**Ergebnis:**
- ✅ Workflow wieder erfolgreich

### 6.4 Dokumentation in README.md

Testergebnisse wurden in README.md dokumentiert.

**Commit:**
```bash
git add README.md
git commit -m "Testergebnisse in README dokumentiert"
git push origin main
```

**✅ Ergebnis:** Mindestens ein erfolgreicher und ein fehlgeschlagener Workflow-Run durchgeführt und dokumentiert.

---

## 7. Erweiterungsaufgabe 1: Pull-Request-Trigger

### 7.1 Workflow erweitern

**`.github/workflows/config-check.yml` - Änderung:**
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]    # NEU
  workflow_dispatch:
```

### 7.2 Pull Request testen

```bash
# Neuen Branch erstellen
git checkout -b feature/update-config

# Änderung vornehmen
echo "listen 443 ssl;" >> config/webserver.conf

# Commit und Push
git add config/webserver.conf
git commit -m "SSL-Port zur Webserver-Konfiguration hinzugefügt"
git push origin feature/update-config
```

**In GitHub:**
1. Pull Request von `feature/update-config` zu `main` geöffnet
2. Workflow automatisch gestartet
3. ✅ Workflow erfolgreich

### 7.3 Dokumentation

In README.md dokumentiert:
- Warum `pull_request`-Trigger in Teams sinnvoll ist
- Test durchgeführt

**Commit:**
```bash
git add README.md
git commit -m "Pull-Request-Trigger in README dokumentiert"
git push origin feature/update-config
```

**✅ Ergebnis:** Workflow reagiert auf Pull Requests, Test durchgeführt.

---

## 8. Erweiterungsaufgabe 2: Zweiten Job einbauen

### 8.1 Workflow erweitern

**`.github/workflows/config-check.yml` - Job 2 hinzugefügt:**
```yaml
deploy-notification:
  runs-on: ubuntu-latest
  needs: validate-config
  if: success()
  
  steps:
    - name: Erfolgsmeldung ausgeben
      run: |
        echo "✅ Die Konfigurationsprüfung war erfolgreich!"
        echo "🚀 CD-Schritt könnte jetzt starten (z.B. Deployment auf Webserver)"
        echo "📦 Nächster Schritt: Konfiguration auf Produktionsserver übertragen"
```

### 8.2 Test

**Commit und Push:**
```bash
git add .github/workflows/config-check.yml
git commit -m "Zweiten Job für Deploy-Benachrichtigung hinzugefügt"
git push origin main
```

**Ergebnis in GitHub Actions:**
- Job 1: `validate-config` ✅ erfolgreich
- Job 2: `deploy-notification` ✅ erfolgreich (nur nach Job 1 gestartet)

### 8.3 Dokumentation in README

**Commit:**
```bash
git add README.md
git commit -m "Zweiten Job in README dokumentiert"
git push origin main
```

**✅ Ergebnis:** Workflow enthält zwei Jobs mit Abhängigkeit.

---

## 9. Erweiterungsaufgabe 3: Prüfung erweitern

### 9.1 Skript erweitern

**scripts/check-config.sh** - Neue Checks:

```bash
# 4. Platzhalter-Check (TODO/FIXME)
if grep -q "TODO" "$CONFIG_FILE" || grep -q "FIXME" "$CONFIG_FILE"; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE enthält noch Platzhalter (TODO oder FIXME)."
    echo "🔧 Bitte ersetze alle Platzhalter, bevor du die Konfiguration bereitstellst."
    exit 1
fi

# 5. Backup-Check (optional)
BACKUP_CONFIG="config/backup.conf"
if [ -f "$BACKUP_CONFIG" ]; then
    echo "ℹ️  Backup-Konfiguration gefunden: $BACKUP_CONFIG"
    if [ ! -s "$BACKUP_CONFIG" ]; then
        echo "⚠️  Warnung: Die Backup-Datei ist leer."
    fi
else
    echo "ℹ️  Keine Backup-Konfiguration gefunden (optional)."
fi
```

### 9.2 Tests

**Test 1 - Mit TODO:**
```bash
echo "# TODO: SSL-Zertifikat hinzufügen" >> config/webserver.conf
./scripts/check-config.sh
# Ausgabe: ❌ Fehler: ... enthält noch Platzhalter (TODO oder FIXME).
```

**Test 2 - Ohne TODO:**
```bash
# TODO entfernen
./scripts/check-config.sh
# Ausgabe: ✅ Erfolg: ... gültig und bereit für das Deployment.
```

### 9.3 Commit

```bash
git add scripts/check-config.sh
git commit -m "Erweiterte Prüfungen: Platzhalter (TODO/FIXME) und Backup-Datei hinzugefügt"
git push origin main
```

### 9.4 Dokumentation in README

**Commit:**
```bash
git add README.md
git commit -m "Erweiterte Prüfungen in README dokumentiert"
git push origin main
```

**✅ Ergebnis:** Skript prüft mehr als nur Existenz und Inhalt.

---

## 10. Reflexionsfragen

### 10.1 Fragen beantwortet

Alle 5 Reflexionsfragen wurden in README.md beantwortet:

1. Welche manuellen Prüfungen wurden automatisiert?
2. Welcher Trigger ist am besten?
3. Was ist CI und wo beginnt CD?
4. Wichtigste Best Practice?
5. Nächste Automatisierungsschritte?

**Commit:**
```bash
git add README.md
git commit -m "Reflexionsfragen beantwortet"
git push origin main
```

**✅ Ergebnis:** Alle Reflexionsfragen sind in README.md dokumentiert.

---

## 11. Zusammenfassung der Commits

| Commit-Nachricht | Datum | Branch |
| :--- | :--- | :--- |
| Initialer Commit: Grundstruktur und Beispiel-Konfiguration | 23.06.2026 | main |
| Skript zur Konfigurationsprüfung hinzugefügt | 23.06.2026 | main |
| README mit CI/CD-Erklärungen ergänzt | 23.06.2026 | main |
| GitHub Actions Workflow für Konfigurationsprüfung hinzugefügt | 23.06.2026 | main |
| Kommentar zur Webserver-Konfiguration hinzugefügt | 23.06.2026 | main |
| TEST: Webserver-Konfiguration geleert | 23.06.2026 | main |
| Webserver-Konfiguration wiederhergestellt | 23.06.2026 | main |
| Testergebnisse in README dokumentiert | 23.06.2026 | main |
| Pull-Request-Trigger zum Workflow hinzugefügt | 23.06.2026 | main |
| SSL-Port zur Webserver-Konfiguration hinzugefügt | 23.06.2026 | feature/update-config |
| Pull-Request-Trigger in README dokumentiert | 23.06.2026 | feature/update-config |
| Zweiten Job für Deploy-Benachrichtigung hinzugefügt | 23.06.2026 | main |
| Zweiten Job in README dokumentiert | 23.06.2026 | main |
| Erweiterte Prüfungen: Platzhalter und Backup-Datei | 23.06.2026 | main |
| Erweiterte Prüfungen in README dokumentiert | 23.06.2026 | main |
| Reflexionsfragen beantwortet | 2306.2026 | feature/update-config |
| README.md komplett aktualisiert | 23.06.2026 | main |

---

## 12. Wichtige Learnings 
1. **YAML-Einrückung ist entscheidend**: Nur Leerzeichen verwenden, keine Tabs.
2. **Git-Workflow**: Immer `git pull` vor `git push`, um Konflikte zu vermeiden.
3. **Lokales Testen**: Skripte immer erst lokal testen, bevor sie in CI laufen.
4. **Kleine Commits**: Nachvollziehbare Änderungen mit klaren Commit-Nachrichten.
5. **CI/CD-Trennung**: CI = Prüfung, CD = Deployment.

---

## 13. Nächste Schritte (Ausblick)

1. **Echter Deploy**: Konfiguration auf einen Test-Server deployen
2. **Test nach Deploy**: Mit `curl` prüfen, ob Webserver läuft
3. **Rollback**: Bei Fehlern automatisch zur letzten Konfiguration zurückkehren
4. **Benachrichtigungen**: Slack/Teams-Webhook bei fehlgeschlagenen Runs
5. **Mehrere Konfigurationen**: `nginx.conf`, `php.ini`, `my.cnf` prüfen

---

## 14. Fazit

**Erfolgreich abgeschlossen:**
- ✅ CI-Pipeline mit GitHub Actions erstellt
- ✅ Lokales Prüfskript geschrieben und getestet
- ✅ Workflow mit Triggern, Jobs und Steps aufgebaut
- ✅ Pull-Request-Trigger integriert
- ✅ Zweiten Job mit Abhängigkeit hinzugefügt
- ✅ Skript um zusätzliche Prüfungen erweitert
- ✅ Alle Ergebnisse dokumentiert

