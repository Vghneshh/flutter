import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../firestore_test.dart';

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
  User? get currentFirebaseUser => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    print('Auth state changed: ${firebaseUser?.uid ?? 'null'}');
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      print('Loading user data for: $userId');
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _user = UserModel.fromMap({'id': doc.id, ...doc.data()!});
        print('User data loaded successfully: ${_user?.name}');
      } else {
        print(
          'User document does not exist in Firestore, creating basic user data',
        );
        // Create a basic user document if it doesn't exist
        final basicUser = UserModel(
          id: userId,
          email: _auth.currentUser?.email ?? '',
          name: _auth.currentUser?.displayName ?? 'User',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        try {
          await _firestore
              .collection('users')
              .doc(userId)
              .set(basicUser.toMap());
          _user = basicUser;
          print('Basic user data created successfully');
        } catch (e) {
          print('Failed to create basic user data: $e');
          // Still set the user even if Firestore fails
          _user = basicUser;
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
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
      print('Starting signup process for: $email');

      // First, create the user with Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(
        'Firebase Auth user created successfully: ${userCredential.user?.uid}',
      );

      if (userCredential.user != null) {
        try {
          print('Creating user document in Firestore...');

          // Create user document in Firestore
          final user = UserModel(
            id: userCredential.user!.uid,
            email: email,
            name: name,
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );

          // Try to save to Firestore, but don't fail if it doesn't work
          try {
            final userData = user.toMap();
            print('User data to save: $userData');

            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(userData);

            print('User document created successfully in Firestore');
          } catch (firestoreError) {
            print('Firestore error (non-critical): $firestoreError');
            // Don't delete the auth user, just log the error
          }

          _user = user;
          _isLoading = false;
          notifyListeners();
          return true;
        } catch (error) {
          print('Unexpected error: $error');
          // If anything else fails, delete the auth user
          await userCredential.user!.delete();
          _error = 'Failed to create user: $error';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      print('Signup error: $e');
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
    print('Error type: ${error.runtimeType}');
    print('Error details: $error');

    if (error is FirebaseAuthException) {
      print('Firebase Auth Error Code: ${error.code}');
      print('Firebase Auth Error Message: ${error.message}');

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
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return 'Authentication error: ${error.message ?? error.code}';
      }
    } else if (error.toString().contains('permission')) {
      return 'Database access denied. Please check your connection.';
    } else if (error.toString().contains('network')) {
      return 'Network error. Please check your internet connection.';
    }

    return 'An unexpected error occurred: $error';
  }

  Future<void> testFirebaseConnection() async {
    try {
      // Test Firestore connection
      await _firestore.collection('test').doc('test').get();
      print('Firebase connection test successful');
    } catch (e) {
      print('Firebase connection test failed: $e');
      throw Exception('Firebase connection failed: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
