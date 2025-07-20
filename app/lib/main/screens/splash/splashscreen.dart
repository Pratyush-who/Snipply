import 'package:flutter/material.dart';
import 'package:snipply/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          token != null ? AppRoute.home : AppRoute.loginName,
        );
      }
    } catch (e) {
      if (mounted) {
        // Fallback to login screen if SharedPreferences fails
        Navigator.pushReplacementNamed(context, AppRoute.loginName);
        
        // Optional: Show error snackbar (remove if you don't want users to see it)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load session data'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Cool App 🚀",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}