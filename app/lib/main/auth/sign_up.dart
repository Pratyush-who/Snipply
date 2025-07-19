import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snipply/routes/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    setState(() => _loading = true);

    final url = Uri.parse('http://localhost:8080/api/auth/signup');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _email.text.trim(),
        'password': _password.text.trim(),
      }),
    );

    setState(() => _loading = false);

    if (res.statusCode == 200 && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _signup,
              child: Text(_loading ? "Signing up..." : "Sign Up"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoute.loginName),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
