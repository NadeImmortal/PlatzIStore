import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Main stream handles navigation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF9775FA);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome To PlatziStore!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please sign in to access the best products available.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // Email Input
            TextField(
              key: const Key('emailField'),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Password Input
            TextField(
              key: const Key('passwordField'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            
            //FORGOT PASSWORD BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('forgotPasswordButton'), 
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              key: const Key('loginButton'),
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: activeColor, // <--- THIS CHANGES THE GREEN TO PURPLE
                  foregroundColor: Colors.white, // Text color
                ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Login"),
            ),
            
            const SizedBox(height: 20),

            // Link to Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New here?"),
                Semantics(
                  label: "createAccountButton",
                  button: true,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                    },
                    child: const Text("Create Account",style: TextStyle(color: activeColor),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}