#!/bin/bash

CONFIG_FILE="config/webserver.conf"
BACKUP_CONFIG="config/backup.conf"

echo "🔍 Prüfe Webserver-Konfiguration..."

# 1. بررسی وجود فایل اصلی
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE existiert nicht."
    exit 1
fi

# 2. بررسی خالی نبودن فایل اصلی
if [ ! -s "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE ist leer."
    exit 1
fi

# 3. بررسی وجود کلمات کلیدی
if ! grep -q "server" "$CONFIG_FILE" && ! grep -q "listen" "$CONFIG_FILE" && ! grep -q "port" "$CONFIG_FILE"; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE enthält kein gültiges Schlüsselwort (server, listen oder port)."
    exit 1
fi

# 4. بررسی وجود کلمات placeholder (جای‌گیرنده)
if grep -q "TODO" "$CONFIG_FILE" || grep -q "FIXME" "$CONFIG_FILE"; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE enthält noch Platzhalter (TODO oder FIXME)."
    echo "🔧 Bitte ersetze alle Platzhalter, bevor du die Konfiguration bereitstellst."
    exit 1
fi

# 5. بررسی فایل backup (اختیاری)
if [ -f "$BACKUP_CONFIG" ]; then
    echo "ℹ️  Backup-Konfiguration gefunden: $BACKUP_CONFIG"
    if [ ! -s "$BACKUP_CONFIG" ]; then
        echo "⚠️  Warnung: Die Backup-Datei ist leer."
    fi
else
    echo "ℹ️  Keine Backup-Konfiguration gefunden (optional)."
fi

# اگر همه چیز درست بود
echo "✅ Erfolg: Die Konfigurationsdatei ist gültig und bereit für das Deployment."
exit 0
