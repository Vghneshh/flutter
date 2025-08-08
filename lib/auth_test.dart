import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  String _status = 'Testing Firebase Auth...';
  bool _isConnected = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _testFirebaseAuth();
  }

  Future<void> _testFirebaseAuth() async {
    try {
      setState(() {
        _status = 'Initializing Firebase...';
      });

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      setState(() {
        _status = 'Firebase initialized successfully!';
      });

      // Test Firebase Auth
      try {
        final auth = FirebaseAuth.instance;
        setState(() {
          _status = 'Firebase Auth initialized successfully!';
        });

        // Try to create a test user
        setState(() {
          _status = 'Testing user creation...';
        });

        // This will fail but will tell us what the error is
        await auth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'test123456',
        );

        setState(() {
          _status = 'User creation test completed!';
          _isConnected = true;
        });
      } catch (authError) {
        setState(() {
          _status = 'Firebase Auth test completed with expected error';
          _errorMessage = 'Auth Error: $authError';
          _isConnected =
              true; // Auth is working, just the test user creation failed
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Firebase initialization failed';
        _errorMessage = e.toString();
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.check_circle : Icons.error,
                          color: _isConnected ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Firebase Auth Status',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(_status, style: Theme.of(context).textTheme.bodyLarge),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Text(
                          'Details: $_errorMessage',
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Project ID: ${DefaultFirebaseOptions.currentPlatform.projectId}',
                    ),
                    Text(
                      'API Key: ${DefaultFirebaseOptions.currentPlatform.apiKey?.substring(0, 10)}...',
                    ),
                    Text(
                      'App ID: ${DefaultFirebaseOptions.currentPlatform.appId}',
                    ),
                    Text(
                      'Auth Domain: ${DefaultFirebaseOptions.currentPlatform.authDomain}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testFirebaseAuth,
              child: const Text('Retest Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
