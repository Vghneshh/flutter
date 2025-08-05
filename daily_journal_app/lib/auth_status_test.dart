import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../providers/auth_provider.dart';

class AuthStatusTestScreen extends StatefulWidget {
  const AuthStatusTestScreen({super.key});

  @override
  State<AuthStatusTestScreen> createState() => _AuthStatusTestScreenState();
}

class _AuthStatusTestScreenState extends State<AuthStatusTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Status Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

          return Padding(
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
                              authProvider?.isAuthenticated == true
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: authProvider?.isAuthenticated == true
                                  ? Colors.green
                                  : Colors.red,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Authentication Status',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatusItem(
                          'isAuthenticated',
                          authProvider?.isAuthenticated.toString() ?? 'null',
                        ),
                        _buildStatusItem(
                          'Firebase User',
                          currentUser?.uid ?? 'null',
                        ),
                        _buildStatusItem(
                          'User Email',
                          currentUser?.email ?? 'null',
                        ),
                        _buildStatusItem(
                          'UserModel',
                          authProvider?.user?.name ?? 'null',
                        ),
                        _buildStatusItem(
                          'UserModel ID',
                          authProvider?.user?.id ?? 'null',
                        ),
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
                          'Debug Information',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatusItem(
                          'Loading',
                          authProvider?.isLoading.toString() ?? 'null',
                        ),
                        _buildStatusItem(
                          'Error',
                          authProvider?.error ?? 'null',
                        ),
                        _buildStatusItem(
                          'Current User UID',
                          currentUser?.uid ?? 'null',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Go to Login'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Go to Signup'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider?.signOut();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed out successfully'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: value == 'null' ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
