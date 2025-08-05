import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.book,
                      size: 60,
                      color: Color(0xFF6B73FF),
                    ),
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .then()
                  .shake(duration: 400.ms),

              const SizedBox(height: 40),

              // App Title
              Text(
                    'Daily Journal',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 800.ms)
                  .slideY(begin: 0.3, duration: 800.ms),

              const SizedBox(height: 8),

              // App Subtitle
              Text(
                    'Track your emotions, reflect on your day',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 800.ms)
                  .slideY(begin: 0.3, duration: 800.ms),

              const SizedBox(height: 80),

              // Loading indicator
              SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 600.ms)
                  .then()
                  .rotate(duration: 2.seconds, curve: Curves.linear),
            ],
          ),
        ),
      ),
    );
  }
}
