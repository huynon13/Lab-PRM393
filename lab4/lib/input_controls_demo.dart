import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  @override
  _InputControlsDemoState createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _rating = 50; // [cite: 148]
  bool _isActive = false;
  String _selectedGenre = "None";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise 2 – Input Controls")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rating (Slider): ${_rating.round()}"),
            Slider(value: _rating, min: 0, max: 100,
                onChanged: (v) => setState(() => _rating = v)), // [cite: 148]

            SwitchListTile(
                title: const Text("Is movie active?"),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v)), // [cite: 148]

            const Text("Genre:", style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(title: const Text("Action"), value: "Action", groupValue: _selectedGenre,
                onChanged: (v) => setState(() => _selectedGenre = v.toString())), // [cite: 148]
            RadioListTile(title: const Text("Comedy"), value: "Comedy", groupValue: _selectedGenre,
                onChanged: (v) => setState(() => _selectedGenre = v.toString())),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await showDatePicker(context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2000), lastDate: DateTime(2100)); // [cite: 149]
                },
                child: const Text("Open Date Picker"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}