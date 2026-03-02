import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_demo.dart';
import 'common_ui_fixes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      // Tách Menu ra thành một Widget riêng (MainMenu) để có Context hợp lệ
      home: MainMenu(
        isDark: _isDark,
        onThemeToggle: () => setState(() => _isDark = !_isDark),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const MainMenu({super.key, required this.isDark, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab 4 - Flutter UI Menu")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenu(context, "Ex 1 - Core Widgets", CoreWidgetsDemo()),
          _buildMenu(context, "Ex 2 - Input Controls", InputControlsDemo()),
          _buildMenu(context, "Ex 3 - Layout Demo", LayoutDemo()),
          _buildMenu(context, "Ex 4 - Structure & Theme", AppStructureDemo(
              isDarkMode: isDark, onThemeToggle: onThemeToggle)),
          _buildMenu(context, "Ex 5 - UI Fixes", CommonUIFixes()),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, String title, Widget target) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        // Bây giờ context này nằm dưới MaterialApp nên Navigator sẽ chạy tốt
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => target)),
      ),
    );
  }
}