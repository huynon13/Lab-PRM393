import 'package:flutter/material.dart';

import 'screens/lab91_assets_read_screen.dart';
import 'screens/lab92_save_load_screen.dart';
import 'screens/lab93_crud_search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeMenuScreen(),
    );
  }
}

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lab 9 - Local JSON Storage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _MenuCard(
            title: 'Lab 9.1 - Read JSON from assets',
            subtitle: 'Load JSON bằng rootBundle.loadString() và hiển thị ListView.',
            icon: Icons.folder_open,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Lab91AssetsReadScreen()),
            ),
          ),
          const SizedBox(height: 10),
          _MenuCard(
            title: 'Lab 9.2 - Save & Load JSON (device storage)',
            subtitle: 'Thêm item, xem list, bấm Save để persist qua restart.',
            icon: Icons.save,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Lab92SaveLoadScreen()),
            ),
          ),
          const SizedBox(height: 10),
          _MenuCard(
            title: 'Lab 9.3 - CRUD + Search (auto-save)',
            subtitle: 'Add/Edit/Delete/Search; tự lưu JSON sau mỗi thay đổi.',
            icon: Icons.manage_search,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Lab93CrudSearchScreen()),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Gợi ý nộp bài: chụp màn hình 3 phần (9.1/9.2/9.3).\\n'
                'Lab 9.2/9.3 sẽ lưu file JSON trong Application Documents Directory.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
