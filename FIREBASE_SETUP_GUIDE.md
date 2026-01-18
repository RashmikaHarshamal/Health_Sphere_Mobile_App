# Firebase Database Setup Guide

## What's Been Done

1. **Added Firebase Dependencies** to `pubspec.yaml`:
   - `firebase_core: ^2.24.0`
   - `cloud_firestore: ^4.14.0`
   - `firebase_auth: ^4.15.0`
   - `firebase_storage: ^11.5.0`

2. **Updated `main.dart`** to initialize Firebase on app startup

3. **Created `firebase_options.dart`** - Configuration file for Firebase credentials

4. **Created `firebase_database_service.dart`** - Singleton service with methods for:
   - Users (save, get, update)
   - Appointments (save, query, update status)
   - Doctors (save, search by specialty/city)
   - Articles (save, get, filter by category)
   - Vaccinations (save, get patient records)
   - Hospitals (save, get by city)
   - Payments (save, get history)
   - Generic operations (save, query, delete, stream)

## Next Steps: Firebase Project Setup

### 1. Create Firebase Project
- Go to [Firebase Console](https://console.firebase.google.com)
- Click "Add project"
- Enter your project name (e.g., "HealthSphere")
- Enable Google Analytics (optional)

### 2. Add Apps to Firebase Project

#### For Android:
1. Click "Android" icon
2. Enter package name: `com.example.flutter_application_2` (check in [android/app/build.gradle.kts](android/app/build.gradle.kts))
3. Download `google-services.json`
4. Place it in `android/app/`

#### For iOS:
1. Click "iOS" icon
2. Enter bundle ID: `com.example.flutterApplication2`
3. Download `GoogleService-Info.plist`
4. Add to Xcode project: Open [ios/Runner.xcworkspace](ios/Runner.xcworkspace) → Runner → Build Phases → add file

#### For Web:
1. Click "Web" icon
2. Register app
3. Copy the config object

#### For Windows/macOS:
1. For now, use Android credentials (Windows/macOS setup requires extra configuration)

### 3. Configure Firebase Credentials

Edit [lib/firebase_options.dart](lib/firebase_options.dart) and replace placeholder values:

**Android credentials** (from `google-services.json`):
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_ANDROID_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'YOUR_DATABASE_URL',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

**iOS credentials** (from `GoogleService-Info.plist`):
```dart
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  databaseURL: 'YOUR_DATABASE_URL',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

**Web credentials** (from Firebase console):
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_WEB_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_AUTH_DOMAIN',
  databaseURL: 'YOUR_DATABASE_URL',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

### 4. Enable Firestore Database
1. In Firebase Console → Firestore Database
2. Click "Create Database"
3. Choose test mode (for development)
4. Select region (closest to you)

### 5. Set Firestore Security Rules
1. Go to Firestore → Rules
2. Replace default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    
    // Allow authenticated users to create appointments
    match /appointments/{document=**} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
      allow update: if request.auth != null;
    }
    
    // Allow anyone to read public data
    match /doctors/{document=**} {
      allow read: if true;
    }
    
    match /hospitals/{document=**} {
      allow read: if true;
    }
    
    match /articles/{document=**} {
      allow read: if true;
    }
    
    // Default deny
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## Usage Examples

### Save User Profile
```dart
await FirebaseDatabaseService().saveUser(
  userId: 'user123',
  name: 'John Doe',
  email: 'john@example.com',
  userType: 'patient',
  phone: '+94712345678',
);
```

### Save Appointment
```dart
String appointmentId = await FirebaseDatabaseService().saveAppointment(
  patientId: 'patient123',
  doctorId: 'doctor456',
  appointmentDate: '2024-02-20',
  timeSlot: '10:00 AM - 10:30 AM',
  notes: 'Initial consultation',
);
```

### Get Patient Appointments
```dart
List<Map<String, dynamic>> appointments = 
  await FirebaseDatabaseService().getPatientAppointments('patient123');
```

### Search Doctors
```dart
List<Map<String, dynamic>> doctors = 
  await FirebaseDatabaseService().searchDoctors(
    specialty: 'Cardiologist',
    city: 'Colombo',
  );
```

### Save Vaccination Record
```dart
String vaccinationId = await FirebaseDatabaseService().saveVaccinationRecord(
  patientId: 'patient123',
  vaccineName: 'COVID-19 (Pfizer)',
  vaccinationDate: '2024-01-15',
  nextDueDate: '2024-07-15',
  location: 'City Hospital',
);
```

### Save Article
```dart
String articleId = await FirebaseDatabaseService().saveArticle(
  title: 'Heart Health Tips',
  content: 'Lorem ipsum...',
  category: 'Cardiology',
  tags: ['heart', 'health', 'exercise'],
  authorId: 'doctor123',
);
```

### Stream Real-Time Data
```dart
FirebaseDatabaseService().streamData('appointments').listen((data) {
  print('Appointments updated: $data');
});
```

## Installing Dependencies

Run in terminal:
```bash
flutter pub get
```

## Running the App

```bash
flutter run
```

## Troubleshooting

### "Firebase not initialized" error
- Make sure `main()` is `async` and `Firebase.initializeApp()` is called
- Check [lib/main.dart](lib/main.dart)

### "Missing google-services.json"
- Download from Firebase Console → Project Settings → Download google-services.json
- Place in `android/app/`

### Firestore permission denied errors
- Update Security Rules (see step 5 above)
- Or temporarily enable test mode (test rules)

### Can't find plugin on iOS
- Run: `cd ios && pod update && cd ..`
- Then: `flutter clean && flutter pub get && flutter run`

## Database Structure (Firestore Collections)

```
users/
  - userId (doc)
    - name, email, userType, phone, profileImage, createdAt, updatedAt

doctors/
  - doctorId (doc)
    - name, specialty, hospital, city, rating, experience, fee, qualifications

appointments/
  - appointmentId (doc)
    - patientId, doctorId, appointmentDate, timeSlot, status, notes

articles/
  - articleId (doc)
    - title, content, category, imageUrl, tags, authorId, createdAt

vaccinations/
  - vaccinationId (doc)
    - patientId, vaccineName, vaccinationDate, nextDueDate

hospitals/
  - hospitalId (doc)
    - name, city, phone, email, address, departments

payments/
  - paymentId (doc)
    - patientId, appointmentId, amount, paymentMethod, status, transactionId
```

## Next: Updating Your Screens

To use Firebase in your screens, import and use `FirebaseDatabaseService`:

```dart
import 'package:flutter_application_2/services/firebase_database_service.dart';

// In your screen...
final _dbService = FirebaseDatabaseService();

// Save data
await _dbService.saveUser(...);

// Fetch data
var user = await _dbService.getUser(userId);

// For real-time updates
_dbService.streamData('collection').listen((data) {
  setState(() {
    _data = data;
  });
});
```

---

**For automatic Firebase setup via FlutterFire CLI** (alternative):
```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```
This will automatically configure Firebase for all platforms based on your setup.
