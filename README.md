# 🚗 RentGo - Car Rental Application

نظام متكامل لتأجير السيارات مع Backend API و Frontend مبني بـ Flutter

![Status](https://img.shields.io/badge/status-active-success.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.10.4-blue.svg)
![Node.js](https://img.shields.io/badge/Node.js-14+-green.svg)
![MySQL](https://img.shields.io/badge/MySQL-5.7+-orange.svg)

---

## 📋 المحتويات

- [الميزات](#-الميزات)
- [التقنيات المستخدمة](#-التقنيات-المستخدمة)
- [متطلبات التشغيل](#-متطلبات-التشغيل)
- [التثبيت والتشغيل](#-التثبيت-والتشغيل)
- [هيكل المشروع](#-هيكل-المشروع)
- [واجهات API](#-واجهات-api)
- [الاختبار](#-الاختبار)

---

## ✨ الميزات

### للمستخدمين (Customers)
- ✅ تسجيل حساب جديد وتسجيل الدخول
- ✅ تصفح السيارات المتاحة مع التفاصيل
- ✅ حجز السيارات بتواريخ محددة
- ✅ إضافة السيارات للمفضلة
- ✅ عرض تاريخ الحجوزات
- ✅ إرسال طلبات الدعم
- ✅ استقبال الإشعارات
- ✅ تقييم الخدمة
- ✅ إدارة الملف الشخصي
- ✅ تغيير كلمة المرور

### للموظفين (Employees)
- ✅ إدارة طلبات التوصيل
- ✅ معالجة طلبات العملاء
- ✅ متابعة حالة الحجوزات

### للمدراء (Managers)
- ✅ إضافة وتعديل السيارات
- ✅ إدارة حسابات الموظفين
- ✅ عرض التقارير والإحصائيات
- ✅ إدارة جميع الحجوزات والطلبات
- ✅ عرض التقييمات

---

## 🛠 التقنيات المستخدمة

### Backend
- **Node.js** - بيئة التشغيل
- **Express.js** - إطار العمل
- **MySQL** - قاعدة البيانات
- **JWT** - المصادقة والأمان
- **bcryptjs** - تشفير كلمات المرور

### Frontend
- **Flutter** - إطار العمل للتطبيق
- **Dart** - لغة البرمجة
- **http** - للاتصال بـ API
- **shared_preferences** - تخزين محلي
- **fl_chart** - الرسوم البيانية
- **flutter_map** - الخرائط
- **image_picker** - اختيار الصور

### Database Schema
```sql
- users (المستخدمين)
- cars (السيارات)
- bookings (الحجوزات)
- deliveries (التوصيلات)
- requests (الطلبات)
- favorites (المفضلة)
- notifications (الإشعارات)
- feedback (التقييمات)
```

---

## 📦 متطلبات التشغيل

قبل البدء، تأكد من تثبيت:

1. **Node.js** (v14 أو أحدث)
   - تحميل من: https://nodejs.org/

2. **MySQL Server** (v5.7 أو أحدث)
   - تحميل من: https://dev.mysql.com/downloads/

3. **Flutter SDK** (v3.10 أو أحدث)
   - تحميل من: https://flutter.dev/docs/get-started/install

4. **Android Studio** (للأيموليتر)
   - تحميل من: https://developer.android.com/studio

---

## 🚀 التثبيت والتشغيل

### الطريقة السريعة (Windows)

```bash
# 1. تشغيل Backend
START_PROJECT.bat

# 2. في terminal آخر، تشغيل Flutter
START_FLUTTER.bat
```

### الطريقة اليدوية

#### 1. إعداد Backend

```bash
# انتقل لمجلد Backend
cd backend

# تثبيت المكتبات
npm install

# نسخ ملف البيئة
copy .env.example .env

# عدّل .env وضع كلمة مرور MySQL
# DB_PASSWORD=your_mysql_password

# تهيئة قاعدة البيانات
npm run init-db

# تشغيل Server
npm start
```

Server سيعمل على: http://localhost:3000

#### 2. إعداد Flutter

```bash
# انتقل لمجلد Flutter
cd Mobile-Project-main

# تثبيت المكتبات
flutter pub get

# تشغيل التطبيق
flutter run
```

---

## 📁 هيكل المشروع

```
Mobile-Project-main/
├── backend/                    # Backend API
│   ├── config/                # إعدادات قاعدة البيانات
│   ├── database/              # Schema وملفات التهيئة
│   ├── middleware/            # Middleware للمصادقة
│   ├── routes/                # API Routes
│   │   ├── auth.js           # Authentication
│   │   ├── cars.js           # Cars management
│   │   ├── bookings.js       # Bookings
│   │   ├── deliveries.js     # Deliveries
│   │   ├── requests.js       # Requests
│   │   ├── employees.js      # Employees
│   │   ├── notifications.js  # Notifications
│   │   ├── users.js          # Users profile
│   │   └── feedback.js       # Feedback
│   ├── .env.example          # مثال ملف البيئة
│   ├── server.js             # ملف Server الرئيسي
│   └── package.json          # المكتبات والإعدادات
│
├── Mobile-Project-main/       # Flutter App
│   ├── lib/
│   │   ├── config/           # إعدادات API
│   │   ├── constants/        # الثوابت والألوان
│   │   ├── screens/          # شاشات التطبيق
│   │   ├── services/         # API Services
│   │   ├── widgets/          # Widgets مشتركة
│   │   └── main.dart         # ملف البداية
│   ├── assets/               # الصور والملفات
│   └── pubspec.yaml          # المكتبات
│
├── START_PROJECT.bat          # تشغيل Backend
├── START_FLUTTER.bat          # تشغيل Flutter
├── SETUP_GUIDE.md            # دليل التثبيت التفصيلي
├── TEST_INSTRUCTIONS.md      # تعليمات الاختبار
├── QUICK_START.md            # البداية السريعة
└── README.md                 # هذا الملف
```

---

## 🔌 واجهات API

### Authentication
```
POST   /api/auth/signup      - تسجيل حساب جديد
POST   /api/auth/login       - تسجيل الدخول
```

### Cars
```
GET    /api/cars             - عرض جميع السيارات
GET    /api/cars/:id         - تفاصيل سيارة
POST   /api/cars             - إضافة سيارة (Manager)
PUT    /api/cars/:id         - تعديل سيارة (Manager)
DELETE /api/cars/:id         - حذف سيارة (Manager)
GET    /api/cars/favorites/list      - المفضلة
POST   /api/cars/favorites/:carId    - إضافة للمفضلة
DELETE /api/cars/favorites/:carId    - حذف من المفضلة
```

### Bookings
```
GET    /api/bookings         - عرض الحجوزات
GET    /api/bookings/:id     - تفاصيل حجز
POST   /api/bookings         - إنشاء حجز
PUT    /api/bookings/:id/status      - تحديث حالة
DELETE /api/bookings/:id     - إلغاء حجز
GET    /api/bookings/history/user    - تاريخ الحجوزات
```

### Notifications
```
GET    /api/notifications              - عرض الإشعارات
GET    /api/notifications/unread/count - عدد غير المقروءة
PUT    /api/notifications/:id/read     - تحديد كمقروء
DELETE /api/notifications/:id          - حذف
```

### Users
```
GET    /api/users/profile           - الملف الشخصي
PUT    /api/users/profile           - تعديل الملف
PUT    /api/users/change-password   - تغيير كلمة المرور
```

لمزيد من التفاصيل، راجع: `backend/README.md`

---

## 🧪 الاختبار

### اختبار Backend

```bash
# تحقق من عمل Server
curl http://localhost:3000/api/health

# يجب أن ترى:
{"status":"ok","message":"RentGo Backend API is running"}
```

### اختبار التطبيق

راجع `TEST_INSTRUCTIONS.md` لسيناريوهات الاختبار الكاملة

---

## 🔐 حسابات تجريبية

**مدير النظام:**
- Username: `admin`
- Password: `password`
- Role: Manager

**بيانات تجريبية:**
- 6 سيارات متاحة
- سيارات من ماركات مختلفة (Toyota, BMW, Mercedes, Honda, Tesla, Nissan)
- أسعار من $55 إلى $120 في اليوم

---

## 🌐 إعدادات الاتصال

### للأيموليتر (Android Emulator):
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### للجهاز الحقيقي:
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000';
```

عدّل في ملف: `lib/config/api_config.dart`

---

## 📝 ملاحظات

- جميع البيانات تُحفظ محلياً في MySQL
- لا يتم رفع أي شيء على الإنترنت
- النظام كامل ويعمل offline
- يمكن تخصيص التطبيق حسب الحاجة

---

## 🤝 المساهمة

المشروع جاهز للاستخدام والتطوير. يمكنك:
- إضافة ميزات جديدة
- تحسين الواجهة
- إضافة لغات جديدة
- تطوير API endpoints إضافية

---

## 📄 الترخيص

هذا المشروع للاستخدام التعليمي والشخصي.

---

## 📞 الدعم

للمساعدة أو الأسئلة:
1. راجع `SETUP_GUIDE.md` للتثبيت التفصيلي
2. راجع `TEST_INSTRUCTIONS.md` لحل المشاكل
3. راجع `backend/README.md` لتوثيق API

---

## 🎉 الخلاصة

لديك الآن نظام كامل ومتكامل لتأجير السيارات يشمل:
- ✅ Backend API كامل
- ✅ قاعدة بيانات MySQL
- ✅ تطبيق Flutter
- ✅ نظام مصادقة وأمان
- ✅ واجهات استخدام جميلة
- ✅ جميع الميزات الأساسية

**استمتع بالتطوير! 🚀**

---

**Built with ❤️ for RentGo**

