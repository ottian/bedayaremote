# بداية ريموت (BedayaRemote)

نسخة خاصة بمؤسسة بداية من RustDesk، مع خادم خاص بالمؤسسة.

## الملفات
| المسار | الوصف |
|---|---|
| `bedaya/server/` | تثبيت خادم بداية (ID + Relay) على سيرفر Ubuntu بأمر واحد |
| `bedaya/apply-branding.sh` | يطبّق الاسم والشعار وعنوان الخادم ومفتاحه على الكود قبل البناء |
| `bedaya/assets/` | شعار بداية (`icon.ico` و `icon.svg` و `logo.png`) |
| `.github/workflows/bedaya-windows.yml` | يبني ملفات تثبيت ويندوز (`.msi` و `.exe`) |

## 1. تشغيل الخادم
```bash
sudo bash bedaya/server/install-server.sh
```
افتح المنافذ TCP 21115-21119 و UDP 21116. السكربت يطبع عنوان الخادم والمفتاح العام.

## 2. ضبط عنوان الخادم في GitHub
Settings → Secrets and variables → Actions → Variables:
- `BEDAYA_SERVER`: عنوان الخادم (IP أو دومين)
- `BEDAYA_KEY`: المفتاح العام

## 3. البناء
Actions → **Build BedayaRemote for Windows** → Run workflow.
بعد انتهاء البناء (حوالي ساعة) حمّل `BedayaRemote-windows-x64` من أسفل صفحة التشغيل.

## الرخصة
RustDesk مرخّص AGPL-3.0: الاستخدام الداخلي حر، والتوزيع خارج المؤسسة يلزم إتاحة الكود المعدَّل.
