# Laza Ecommerce App

## 1. Project Overview
This is a mobile e-commerce app built with **Flutter**. It allows users to browse products, add them to a cart, save favorites, and login securely using firebase authentication.

**Key Features:**
* **Login & Signup:** Uses Firebase Authentication.
* **Products:** Loads real data from an API.
* **Cart & Favorites:** Saves your items to the database (Firestore).
* **Theme:** Custom Teal & Coral design.

---

## 2. How to Set Up

### Step 1: Install Dependencies
1.  Download this project.
2.  Open the folder in VS Code.
3.  Open the terminal and run:
    ```bash
    flutter pub get
    ```
    then
    flutter run

### Step 2: Firebase Setup
1.  Go to the [Firebase Console](https://console.firebase.google.com/) and create a project.
2.  **Enable Auth:** Go to Authentication and turn on **Email/Password**.
3.  **Enable Database:** Go to Firestore Database and create a database (start in **Test Mode**).
4.  **Connect Android:**
    * In Project Settings, add an Android app.
    * Use package name: `com.example.flutter_application_1`
    * Download `google-services.json` and put it in the `android/app/` folder.

### Testing
### The test scripts are in the /appium_tests folder.

To run the tests:
Make sure the Appium server is running.
Run the scripts:
python appium_tests/auth_test.py
python appium_tests/cart_test.py