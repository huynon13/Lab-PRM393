import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise 1 – Core Widgets")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Welcome to Flutter UI",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)), // [cite: 139]
            ),
            const Icon(Icons.movie_creation_rounded, size: 80, color: Colors.blue), // [cite: 140]
            const SizedBox(height: 20),
            Image.network(
              'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=500', // [cite: 141]
              height: 200, width: double.infinity, fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Card( // [cite: 142]
              margin: const EdgeInsets.all(16),
              child: const ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text("Movie Item"),
                subtitle: Text("This is a sample ListTile inside a Card."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}