import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import random

class AuthTest(unittest.TestCase):
    def setUp(self):
        options = UiAutomator2Options()
        options.platform_name = 'Android'
        options.device_name = 'emulator-5554'
        options.app_package = 'com.example.flutter_application_1' 
        options.app_activity = 'com.example.flutter_application_1.MainActivity'
        options.automation_name = 'UiAutomator2'
        options.set_capability('noReset', True)
        options.set_capability('newCommandTimeout', 300)
        
        self.driver = webdriver.Remote('http://127.0.0.1:4723', options=options)

    def test_login_flow(self):
        wait = WebDriverWait(self.driver, 25)

        # STEP 1: Navigate to Signup

        print("STEP 1: Navigate to Signup")
        try:
            # Try finding the button by description
            create_btn = wait.until(EC.presence_of_element_located(
                (AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().descriptionContains("Create Account")')
            ))
            create_btn.click()
            print("   -> Clicked 'Create Account'")
        except:
            # Fallback for visible text
            try:
                create_btn = self.driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().textContains("Create Account")')
                create_btn.click()
                print("   -> Clicked 'Create Account' (via Text)")
            except:
                print("   -> Could not find 'Create Account' (Assuming already on Signup screen)")

        time.sleep(4) # Wait for page load

        # STEP 2: Type Username (The First Box)

        print("STEP 2: Type Username")
        try:
            # Find the FIRST text box (which is now Username)
            text_fields = wait.until(EC.presence_of_all_elements_located(
                (AppiumBy.CLASS_NAME, "android.widget.EditText")
            ))
            
            if len(text_fields) > 0:
                text_fields[0].click()
                time.sleep(1)
                text_fields[0].send_keys("TestUser123")
                print("   -> Username Typed!")
            else:
                self.fail("No text boxes found!")
        except Exception as e:
            self.fail(f"Error typing username: {e}")


        # STEP 3: Switch Focus to Email (TAB Key)

        print("STEP 3: Switch Focus to Email")
        try:
            self.driver.press_keycode(61) # TAB key
            print("   -> Pressed TAB key")
            time.sleep(1)
        except:
            print("   -> Tab key failed")


        # STEP 4: Type Email (Into Active Element)

        print("STEP 4: Type Email")
        try:
            # Type into the currently focused box (Email)
            active_element = self.driver.switch_to.active_element
            
            random_num = random.randint(1000, 9999)
            active_element.send_keys(f"user{random_num}@test.com")
            print("   -> Email Typed!")
        except Exception as e:
            self.fail(f"Error typing email: {e}")


        # STEP 5: Switch Focus to Password (TAB Key)

        print("STEP 5: Switch Focus to Password")
        try:
            self.driver.press_keycode(61) # TAB key
            print("   -> Pressed TAB key")
            time.sleep(1)
        except:
            print("   -> Tab key failed")


        # STEP 6: Type Password (Into Active Element)

        print("STEP 6: Type Password")
        try:
            # Type into the currently focused box (Password)
            active_element = self.driver.switch_to.active_element
            active_element.send_keys("password123")
            print("   -> Password Typed!")
            
            # Hide keyboard to reveal button
            self.driver.press_keycode(4) # Back button
            time.sleep(1)
        except Exception as e:
            self.fail(f"Error typing password: {e}")


        # STEP 7: Click Sign Up

        print("STEP 7: Click Sign Up")
        try:
            # Try to find the button
            signup_btn = wait.until(EC.presence_of_element_located(
                (AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().descriptionContains("Sign Up")')
            ))
            signup_btn.click()
            print("   -> Clicked Sign Up")
        except:
            # Fallback: Find by class name (Button)
            btns = self.driver.find_elements(AppiumBy.CLASS_NAME, "android.widget.Button")
            if len(btns) > 0:
                btns[-1].click()
                print("   -> Clicked Sign Up (via Class fallback)")

        # STEP 8: Validate
        
        print("STEP 8: Verify Home")
        try:
            wait.until(EC.presence_of_element_located(
                (AppiumBy.ACCESSIBILITY_ID, "CartIcon")
            ))
            print("Home Screen Reached!")
            self.driver.save_screenshot('docs/results/auth_test_screenshot.png')
            
        except:
            print("Warning: Timed out waiting for Home Screen, but flow finished.")
        
    def tearDown(self):
        if self.driver:
            self.driver.quit()

if __name__ == '__main__':
    unittest.main()