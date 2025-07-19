import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snipply/main/auth/loginpage.dart';
import 'package:snipply/main/auth/sign_up.dart';
import 'package:snipply/main/screens/splash/splashscreen.dart';
import 'package:snipply/main/screens/ui/homepage.dart';
// Add other screen imports here

class AppRoute {
  static const String splashName = '/splash';
  static const String loginName = '/login';
  static const String signupName = '/signup';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case loginName:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case signupName:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
