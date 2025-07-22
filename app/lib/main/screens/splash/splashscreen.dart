import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snipply/routes/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); 

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      Navigator.pushNamedAndRemoveUntil(
        context,
        token != null ? AppRoute.home : AppRoute.loginName,
        (route) => false,
      );
    } catch (e) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.loginName,
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load session data'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger navigation after first frame
    Future.microtask(() => _navigate(context));

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
