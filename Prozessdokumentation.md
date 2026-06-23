
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
