#!/usr/bin/env bash
# تثبيت خادم بداية ريموت على Ubuntu/Debian
# الاستخدام: sudo bash install-server.sh
set -euo pipefail

INSTALL_DIR=/opt/bedaya-remote

if ! command -v docker >/dev/null; then
  curl -fsSL https://get.docker.com | sh
fi

mkdir -p "$INSTALL_DIR"
cp "$(dirname "$0")/docker-compose.yml" "$INSTALL_DIR/"
cd "$INSTALL_DIR"
docker compose up -d

# فتح المنافذ المطلوبة إن كان ufw مفعّلاً
if command -v ufw >/dev/null && ufw status | grep -q active; then
  ufw allow 21115:21119/tcp
  ufw allow 21116/udp
fi

echo "انتظار توليد المفتاح..."
for _ in $(seq 1 30); do
  [ -f data/id_ed25519.pub ] && break
  sleep 1
done

echo
echo "تم تشغيل الخادم."
echo "عنوان الخادم: $(curl -fsS https://api.ipify.org || hostname -I | awk '{print $1}')"
echo "المفتاح العام (احتفظ به لبناء العميل):"
cat data/id_ed25519.pub
echo
