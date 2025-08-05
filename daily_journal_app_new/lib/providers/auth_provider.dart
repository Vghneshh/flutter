import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _auth.currentUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _user = UserModel.fromMap({'id': doc.id, ...doc.data()!});
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load user data: $e';
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to sign out: $e';
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? profileImageUrl}) async {
    if (_user == null) return;

    try {
      final updatedUser = _user!.copyWith(
        name: name,
        profileImageUrl: profileImageUrl,
      );

      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update(updatedUser.toMap());

      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update profile: $e';
      notifyListeners();
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return error.message ?? 'An error occurred during authentication.';
      }
    }
    return 'An unexpected error occurred.';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
