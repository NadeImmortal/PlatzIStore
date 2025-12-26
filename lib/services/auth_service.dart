import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth changes
  Stream<User?> get user => _auth.userChanges();

  // Sign Up & Save to Firestore
  Future<void> signUp({
    required String email, 
    required String password,
    required String username,
  }) async {
    try {
      // 1. Create User in Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // 2. Save User Data to Firestore
      User? user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        // 3. Update Display Name and FORCE RELOAD
        await user.updateDisplayName(username);
        await user.reload(); //"HELLO GUEST"
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Password Reset
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Login
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}