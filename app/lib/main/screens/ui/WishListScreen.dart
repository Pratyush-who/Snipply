import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(
        child: Text(
          'Wishlist Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}