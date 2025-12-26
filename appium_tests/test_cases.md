# Appium Test Cases

## Tools & Versions
* **Appium Server:** v2.x
* **Client Library:** Appium-Python-Client v3.1.0
* **Test Framework:** Python `unittest`
* **Device:** Android Emulator (Pixel 5, API 30+)

---

## Test Case 1: Authentication Flow
**Description:** Verifies that a user can successfully sign up and automatically navigate to the Home screen.
**Pre-conditions:**
* App is installed and launched.
* User is on the "Let's Get Started" or Login screen.
* Database is reachable.

**Steps:**
1.  Click the "Create Account" button.
2.  Enter a valid email address (e.g., `testuser@example.com`).
3.  Enter a valid password (e.g., `password123`).
4.  Click the "Sign Up" button.
5.  Goes to the HomeScreen

**Expected Results:**
* The "Home" screen is displayed.
* The user's email is visible in the Profile drawer.
* No error messages are shown.


## Test Case 2: Cart Management
**Description:** Verifies that a product can be added to the cart and appears in the Cart screen.
**Pre-conditions:**
* User is logged in.
* Home screen is displayed with products loaded from API.
* Cart is initially empty.

**Steps:**
1.  Tap on the first product in the list (Home Screen).
2.  On the Detail screen, tap "Add to Cart".
3.  Navigate back to Home.
4.  Tap the "Cart" (Bag) icon in the top-right corner.

**Expected Results:**
* The Cart screen opens.
* The product selected in Step 1 is listed in the cart.
* The "Checkout" button is visible.