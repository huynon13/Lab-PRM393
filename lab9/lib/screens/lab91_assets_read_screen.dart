import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Lab91AssetsReadScreen extends StatefulWidget {
  const Lab91AssetsReadScreen({super.key});

  @override
  State<Lab91AssetsReadScreen> createState() => _Lab91AssetsReadScreenState();
}

class _Lab91AssetsReadScreenState extends State<Lab91AssetsReadScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await rootBundle.loadString('assets/data/sample_items.json');
      final decoded = jsonDecode(raw);
      final list = (decoded as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList(growable: false);
      setState(() => _items = list);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Read JSON From Assets'),
        actions: [
          IconButton(
            onPressed: _load,
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Lỗi đọc assets JSON:\n$_error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final it = _items[index];
                    final name = (it['name'] ?? '').toString();
                    final category = (it['category'] ?? '').toString();
                    final price = it['price'];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${it['id'] ?? '?'}')),
                      title: Text(name),
                      subtitle: Text('Loại: $category'),
                      trailing: Text(
                        price == null ? '' : '${price.toString()}đ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
    );
  }
}

