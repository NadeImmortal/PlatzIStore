# Test Execution Summary

## Overview
This document summarizes the automated testing results for the Platzi Store Flutter application. The tests were executed using Appium with Python on an Android Emulator (Pixel API 35).

| Test Suite | Status | Duration | Log File | Screenshot |
| :--- | :--- | :--- | :--- | :--- |
| **Authentication Flow** | ✅ PASSED | ~20s | `auth_test_log.txt` | `auth_test_screenshot.png` |
| **Cart Navigation** | ✅ PASSED | ~45 | `cart_test_log.txt` | `cart_test_screenshot.png` |

---

## 1. Authentication Test (`auth_test.py`)
**Objective:** Verify that a user can successfully create an account/login and navigate to the Home Screen.
* **Steps Executed:**
    1.  Launch App.
    2.  Navigate to "Create Account".
    3.  Enter valid Email.
    4.  Enter valid Password (using TAB navigation to bypass UI focus issues).
    5.  Click "Sign Up".
    6.  Verify redirection to Home Screen (Cart Icon visible).
* **Observation:** The test successfully handles the keyboard obstruction issue by using the Android "Back" key event and "Tab" key navigation.

## 2. Cart Test (`cart_test.py`)
**Objective:** Verify that a user can select a product, add it to the cart, and view the cart.
* **Steps Executed:**
    1.  Verify Home Screen is loaded.
    2.  Select a product using coordinate tapping (robust fallback strategy).
    3.  Click "Add to Cart".
    4.  Navigate to Cart Screen.
    5.  Verify the "Checkout" button is visible (indicating items are present).
* **Observation:** The test uses a hybrid strategy (Visual Text Search + Coordinate Fallback) to reliably interact with product elements regardless of screen size.

---

## Conclusion
Both critical user journeys (Authentication and Shopping Flow) are functioning correctly. The automation scripts are robust against common emulator timing issues and keyboard obstructions.