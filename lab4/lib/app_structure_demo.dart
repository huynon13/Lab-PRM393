import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  final Function onThemeToggle;
  final bool isDarkMode;

  const AppStructureDemo({required this.onThemeToggle, required this.isDarkMode});

  @override
  _AppStructureDemoState createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // [cite: 161]
      appBar: AppBar( // [cite: 163]
        title: const Text("Exercise 4 – App Structure"),
        actions: [
          const Center(child: Text("Dark")),
          Switch(value: widget.isDarkMode, onChanged: (v) => widget.onThemeToggle()), // [cite: 167]
        ],
      ),
      body: const Center(child: Text("This is a simple screen with theme toggle.")), // [cite: 164]
      floatingActionButton: FloatingActionButton( // [cite: 165]
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}