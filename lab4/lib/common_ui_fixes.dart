import 'package:flutter/material.dart';

class CommonUIFixes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise 5 – Common UI Fixes")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Correct ListView inside Column using Expanded",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded( // Sửa lỗi bằng Expanded
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.movie), title: Text("Movie A")),
                ListTile(leading: Icon(Icons.movie), title: Text("Movie B")),
                ListTile(leading: Icon(Icons.movie), title: Text("Movie C")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}