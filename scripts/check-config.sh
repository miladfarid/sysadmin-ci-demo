#!/bin/bash

CONFIG_FILE="config/webserver.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ خطا: فایل کانفیگ وجود ندارد."
    exit 1
fi

if [ ! -s "$CONFIG_FILE" ]; then
    echo "❌ خطا: فایل کانفیگ خالی است."
    exit 1
fi

if ! grep -q "server" "$CONFIG_FILE" && ! grep -q "listen" "$CONFIG_FILE" && ! grep -q "port" "$CONFIG_FILE"; then
    echo "❌ خطا: در فایل کانفیگ کلمه server یا listen یا port پیدا نشد."
    exit 1
fi

echo "✅ موفق: فایل کانفیگ درست است."
exit 0
