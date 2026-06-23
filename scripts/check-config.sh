#!/bin/bash

# تعریف مسیر فایل کانفیگ
CONFIG_FILE="config/webserver.conf"

# 1. بررسی وجود فایل
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE existiert nicht."
    exit 1
fi

# 2. بررسی خالی نبودن فایل
if [ ! -s "$CONFIG_FILE" ]; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE ist leer."
    exit 1
fi

# 3. بررسی وجود کلمه کلیدی (مثلاً 'server' یا 'listen')
if ! grep -q "server" "$CONFIG_FILE" && ! grep -q "listen" "$CONFIG_FILE" && ! grep -q "port" "$CONFIG_FILE"; then
    echo "❌ Fehler: Die Datei $CONFIG_FILE enthält kein gültiges Schlüsselwort (server, listen oder port)."
    exit 1
fi

# اگر همه چیز درست بود
echo "✅ Erfolg: Die Konfigurationsdatei ist gültig."
exit 0
