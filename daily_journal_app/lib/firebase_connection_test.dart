import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

class FirebaseConnectionTest extends StatefulWidget {
  const FirebaseConnectionTest({super.key});

  @override
  State<FirebaseConnectionTest> createState() => _FirebaseConnectionTestState();
}

class _FirebaseConnectionTestState extends State<FirebaseConnectionTest> {
  String _status = 'Testing Firebase connection...';
  bool _isConnected = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      setState(() {
        _status = 'Initializing Firebase...';
      });

      // Test Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      setState(() {
        _status = 'Firebase Core initialized successfully!';
      });

      // Test Firestore connection
      try {
        await FirebaseFirestore.instance.collection('test').limit(1).get();
        setState(() {
          _status = 'Firestore connection successful!';
          _isConnected = true;
        });
      } catch (e) {
        setState(() {
          _status = 'Firestore connection failed';
          _errorMessage = e.toString();
        });
      }

      // Test Firebase Auth
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        setState(() {
          _status = 'Firebase Auth initialized successfully!';
        });
      } catch (e) {
        setState(() {
          _status = 'Firebase Auth initialization failed';
          _errorMessage = e.toString();
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
        title: const Text('Firebase Connection Test'),
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
                          'Firebase Connection Status',
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
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          'Error: $_errorMessage',
                          style: TextStyle(color: Colors.red[700]),
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
                      'Storage Bucket: ${DefaultFirebaseOptions.currentPlatform.storageBucket}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testFirebaseConnection,
              child: const Text('Retest Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
