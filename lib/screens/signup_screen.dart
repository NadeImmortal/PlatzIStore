import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _signUp() async {
    setState(() => _isLoading = true);
    try {
      // 1. Create the account using your existing service
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );


      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Manually set the Display Name immediately
        await user.updateDisplayName(_usernameController.text.trim());
        
        // Reload the user to ensure the app sees the new name
        await user.reload(); 
      }

      if (mounted) {
        // Depending on your app flow, you might want to use pushReplacementNamed
        // instead of pop if pop takes you back to Login. 
        // But if your app auto-detects login, pop is fine.
        Navigator.pop(context); 
      }
      
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
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 1. Username Field
              Semantics(
                label: "signupUsername",
                container: true,
                textField: true,
                child: TextField(
                  controller: _usernameController,
                  cursorColor: activeColor,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: activeColor, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: activeColor),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. Email Field
              Semantics(
                label: "signupEmail",
                container: true,
                textField: true,
                child: TextField(
                  controller: _emailController,
                  cursorColor: activeColor,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: activeColor, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: activeColor),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Password Field
              Semantics(
                label: "signupPassword",
                container: true,
                textField: true,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: activeColor,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: activeColor, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: activeColor),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 4. Signup Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Semantics(
                  label: "signupButton",
                  container: true,
                  button: true,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}