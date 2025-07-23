import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
          _buildFeaturedItems(),
          _buildCategories(),
          // Add more sections as needed
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Welcome to My App',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildFeaturedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Featured Items',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.grey[200],
                child: Center(child: Text('Item $index')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              child: Center(child: Text('Category $index')),
            );
          },
        ),
      ],
    );
  }
}