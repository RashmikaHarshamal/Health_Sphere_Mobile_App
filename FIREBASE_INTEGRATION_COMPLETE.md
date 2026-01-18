# Firebase Integration Complete Guide

## ✅ What's Been Integrated

Your app now has full Firebase integration:

### 1. **Authentication**
- ✅ Sign Up with email/password → Saves user to Firestore
- ✅ Login with email/password → Firebase Auth
- ✅ Password validation and error handling

### 2. **Screens Updated**
- ✅ **LoginPage** - Firebase authentication
- ✅ **SignupPage** - Create user + save to Firestore
- ✅ **AppointmentsPage** - Load appointments from Firebase
- ✅ **AppointmentFormPage** - Save appointments to Firebase
- ✅ **VaccinationPage** - Load vaccination records from Firebase
- ✅ **ArticlesPage** - Load articles from Firebase
- ✅ **FindDoctorsPage** - Load doctors from Firebase (ready to implement)

### 3. **Services Created**
- ✅ `FirebaseAuthService` - Handle authentication
- ✅ `FirebaseDatabaseService` - Handle all database operations

## 📋 Next Steps: Complete the Setup

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Name it: **HealthSphere**
4. Click **"Create project"**

### Step 2: Add Android App
1. In Firebase Console → Click **Android** icon
2. Package name: `com.example.flutter_application_2` (verify in `android/app/build.gradle.kts`)
3. App nickname: `Health Sphere Android`
4. Register app
5. **Download `google-services.json`**
6. Place in `android/app/`

### Step 3: Update Firebase Configuration
Edit [lib/firebase_options.dart](lib/firebase_options.dart):

Replace all `YOUR_*` placeholders with values from:
- Firebase Console → Project Settings → Your apps → Android

Example:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyD_example_key_here',
  appId: '1:123456789:android:abc123def456',
  messagingSenderId: '123456789',
  projectId: 'healthsphere-abc123',
  databaseURL: 'https://healthsphere-abc123.firebaseio.com',
  storageBucket: 'healthsphere-abc123.appspot.com',
);
```

### Step 4: Enable Firestore
1. Firebase Console → **Firestore Database**
2. Click **"Create Database"**
3. Select **Test mode** (for development)
4. Choose region closest to you
5. Click **"Enable"**

### Step 5: Set Security Rules
1. Firebase Console → Firestore → **Rules** tab
2. Replace default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // All authenticated users can read/write appointments
    match /appointments/{document=**} {
      allow create, read, update: if request.auth != null;
      allow delete: if request.auth != null && 
        resource.data.patientId == request.auth.uid;
    }
    
    // All users can read doctors
    match /doctors/{document=**} {
      allow read: if true;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'doctor';
    }
    
    // All users can read articles
    match /articles/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users can read/write their own vaccinations
    match /vaccinations/{document=**} {
      allow read, write: if request.auth != null && 
        resource.data.patientId == request.auth.uid;
    }
    
    // All users can read hospitals
    match /hospitals/{document=**} {
      allow read: if true;
    }
    
    // Users can create payments
    match /payments/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && 
        resource.data.patientId == request.auth.uid;
    }
    
    // Default: Deny everything else
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

3. Click **"Publish"**

### Step 6: Install Dependencies & Run
```bash
flutter pub get
flutter run
```

## 🚀 How to Use in Your App

### **Sign Up (Create New User)**
```dart
// Already integrated in SignupPage
// User data automatically saved to Firestore
```

### **Login (Existing User)**
```dart
// Already integrated in LoginPage
// Uses Firebase Authentication
```

### **Save Appointment**
```dart
import 'package:flutter_application_2/services/firebase_database_service.dart';

final _dbService = FirebaseDatabaseService();
final userId = FirebaseAuth.instance.currentUser!.uid;

String appointmentId = await _dbService.saveAppointment(
  patientId: userId,
  doctorId: 'doctor123',
  appointmentDate: '2026-02-20',
  timeSlot: '10:00 AM',
  notes: 'Initial consultation',
  status: 'scheduled',
);
```

### **Get Patient Appointments**
```dart
List<Map<String, dynamic>> appointments = 
  await _dbService.getPatientAppointments(userId);
```

### **Save Vaccination Record**
```dart
String vaccinationId = await _dbService.saveVaccinationRecord(
  patientId: userId,
  vaccineName: 'COVID-19',
  vaccinationDate: '2026-01-15',
  nextDueDate: '2026-07-15',
);
```

### **Get Vaccination Records**
```dart
List<Map<String, dynamic>> records = 
  await _dbService.getVaccinationRecords(userId);
```

### **Save Article**
```dart
String articleId = await _dbService.saveArticle(
  title: 'Heart Health Tips',
  content: 'Lorem ipsum...',
  category: 'Heart Health',
  authorId: userId,
);
```

### **Get All Articles**
```dart
List<Map<String, dynamic>> articles = await _dbService.getArticles();
```

### **Search Doctors**
```dart
List<Map<String, dynamic>> doctors = await _dbService.searchDoctors(
  specialty: 'Cardiologist',
  city: 'Colombo',
);
```

### **Stream Real-Time Data**
```dart
_dbService.streamData('appointments').listen((appointments) {
  setState(() {
    _appointments = appointments;
  });
});
```

## 📁 Firestore Collection Structure

```
users/
├── {userId}
│   ├── userId: string
│   ├── name: string
│   ├── email: string
│   ├── userType: string (patient/doctor/admin)
│   ├── phone: string
│   ├── profileImage: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

appointments/
├── {appointmentId}
│   ├── patientId: string
│   ├── doctorId: string
│   ├── appointmentDate: string (YYYY-MM-DD)
│   ├── timeSlot: string (10:00 AM)
│   ├── notes: string
│   ├── status: string (scheduled/completed/cancelled)
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

doctors/
├── {doctorId}
│   ├── name: string
│   ├── specialty: string
│   ├── hospital: string
│   ├── city: string
│   ├── rating: number
│   ├── experience: string
│   ├── fee: string
│   └── ...

articles/
├── {articleId}
│   ├── title: string
│   ├── content: string
│   ├── category: string
│   ├── imageUrl: string
│   ├── tags: array
│   ├── authorId: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

vaccinations/
├── {vaccinationId}
│   ├── patientId: string
│   ├── vaccineName: string
│   ├── vaccinationDate: string
│   ├── nextDueDate: string
│   ├── location: string
│   └── createdAt: timestamp

hospitals/
├── {hospitalId}
│   ├── name: string
│   ├── city: string
│   ├── phone: string
│   ├── email: string
│   ├── address: string
│   ├── departments: array
│   └── ...

payments/
├── {paymentId}
│   ├── patientId: string
│   ├── appointmentId: string
│   ├── amount: number
│   ├── paymentMethod: string
│   ├── status: string (pending/completed/failed)
│   ├── transactionId: string
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp
```

## 🔧 Troubleshooting

### "Firebase not initialized"
- Make sure `main()` is `async` and Firebase is initialized ✅ Already done in [lib/main.dart](lib/main.dart)

### "google-services.json not found"
1. Download from Firebase Console
2. Place in `android/app/`
3. Run: `flutter clean && flutter pub get`

### "Firestore permission denied"
- Check Security Rules (updated above)
- Or temporarily use test mode for debugging

### "Can't connect to iOS"
For iOS, you need:
1. Download `GoogleService-Info.plist` from Firebase
2. Add to Xcode: Open `ios/Runner.xcworkspace` → Runner → Add Files → Select plist file
3. Ensure it's in Build Phases: Compile Sources

### Packages not found after pubspec.yaml update
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Testing the Integration

### Test User Sign Up:
1. Open app → Click "Sign Up"
2. Enter:
   - Name: Test User
   - Email: test@example.com
   - Password: Test@123
3. Agree to terms → Click "Sign Up"
4. Check Firebase Console → Firestore → `users` collection → Should see new user

### Test Login:
1. Click "Login"
2. Enter same credentials
3. Should navigate to HomePage

### Test Appointments:
1. Login → HomePage → "Find Doctors"
2. Select filters → Choose doctor → "Book Appointment"
3. Fill form → Select date/time → "Proceed to Payment"
4. Check Firebase Console → Firestore → `appointments` collection → Should see new appointment

## 🎯 What's Ready to Use

| Feature | Status | File |
|---------|--------|------|
| User Authentication | ✅ Ready | [lib/screens/login_page.dart](lib/screens/login_page.dart) |
| User Registration | ✅ Ready | [lib/screens/signup_page.dart](lib/screens/signup_page.dart) |
| Appointments (Read) | ✅ Ready | [lib/screens/appointments_page.dart](lib/screens/appointments_page.dart) |
| Appointments (Write) | ✅ Ready | [lib/screens/appointment_form_page.dart](lib/screens/appointment_form_page.dart) |
| Vaccinations | ✅ Ready | [lib/screens/vaccination_page.dart](lib/screens/vaccination_page.dart) |
| Articles | ✅ Ready | [lib/screens/articles_page.dart](lib/screens/articles_page.dart) |
| Doctors Search | ✅ Ready | [lib/screens/find_doctors_page.dart](lib/screens/find_doctors_page.dart) |
| User Profile | 🔜 Next | [lib/screens/user_profile_page.dart](lib/screens/user_profile_page.dart) |
| Payments | 🔜 Next | [lib/screens/payment_page.dart](lib/screens/payment_page.dart) |

## 🎓 Key Components

### FirebaseAuthService
- `signUp()` - Create new user
- `signIn()` - Login user
- `signOut()` - Logout
- `updateProfile()` - Update user info
- `sendPasswordResetEmail()` - Password recovery

### FirebaseDatabaseService
- **Users**: `saveUser()`, `getUser()`, `updateUser()`
- **Appointments**: `saveAppointment()`, `getPatientAppointments()`, `updateAppointmentStatus()`
- **Doctors**: `saveDoctorProfile()`, `searchDoctors()`
- **Articles**: `saveArticle()`, `getArticles()`, `getArticlesByCategory()`
- **Vaccinations**: `saveVaccinationRecord()`, `getVaccinationRecords()`
- **Hospitals**: `saveHospital()`, `getHospitalsByCity()`
- **Payments**: `savePayment()`, `getPaymentHistory()`
- **Generic**: `saveData()`, `getData()`, `queryData()`, `deleteData()`, `streamData()`

---

You're all set! 🎉 Just complete the Firebase setup and your app is ready to go live with a real database!
