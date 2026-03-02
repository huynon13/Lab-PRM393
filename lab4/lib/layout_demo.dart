import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  final List<String> movies = ["Avatar", "Inception", "Interstellar", "Joker"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise 3 – Layout Demo")),
      body: Column( // [cite: 154]
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20), // [cite: 155, 157]
            child: Text("Now Playing", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded( // Sử dụng Expanded để ListView không gây lỗi chiều cao
            child: ListView.builder( // [cite: 156]
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(movies[index][0])),
                    title: Text(movies[index]),
                    subtitle: const Text("Sample description"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}