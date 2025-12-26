# Firebase Setup Guide for Platzi Store

## 1. Create Project
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Click **"Add project"** 

## 2. Add Android App
1. Click the **Android Icon** (robot) on the dashboard.
2. Enter the **Package Name**: `com.example.flutter_application_1`
3. Click **"Register app"**.
4. Download `google-services.json`.
5. Move this file into your project folder: `android/app/google-services.json`.
6. Click **"Next"** through the remaining steps.

## 3. Enable Authentication
1. On the left sidebar, go to **Build > Authentication**.
2. Click **"Get started"**.
3. Select **"Native Providers"** tab or **"Sign-in method"** tab.
4. Click **"Email/Password"**.
5. Toggle **Enable** (leave "Email link" disabled).
6. Click **"Save"**.

## 4. Enable Firestore Database
1. On the left sidebar, go to **Build > Firestore Database**.
2. Click **"Create database"**.
3. Choose a location
4. Select **"Start in test mode"** initially
5. Click **"Create"**.

## 5. Apply Security Rules
1. In the Firestore Database tab, click **"Rules"** at the top.
2. Delete the existing code and paste the content from your `firestore.rules` file:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /carts/{userId}/items/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /favorites/{userId}/items/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }