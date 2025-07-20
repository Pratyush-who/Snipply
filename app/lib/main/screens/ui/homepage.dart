import 'package:flutter/material.dart';
import 'package:snipply/routes/routes.dart';
import 'package:snipply/service/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoute.loginName,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Welcome to the Home Page", style: TextStyle(fontSize: 22)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoggingOut ? null : _handleLogout,
        child: _isLoggingOut
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}