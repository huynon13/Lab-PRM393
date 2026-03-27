import 'package:flutter/material.dart';

import '../services/json_storage.dart';

class Lab92SaveLoadScreen extends StatefulWidget {
  const Lab92SaveLoadScreen({super.key});

  @override
  State<Lab92SaveLoadScreen> createState() => _Lab92SaveLoadScreenState();
}

class _Lab92SaveLoadScreenState extends State<Lab92SaveLoadScreen> {
  final _storage = const JsonStorage(fileName: 'lab92_items.json');

  final _nameCtl = TextEditingController();
  final _noteCtl = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _noteCtl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final raw = await _storage.readJsonListOrEmpty();
    setState(() {
      _items = raw.map((e) => (e as Map).cast<String, dynamic>()).toList();
      _loading = false;
    });
  }

  int _nextId() {
    final ids = _items
        .map((e) => e['id'])
        .whereType<num>()
        .map((e) => e.toInt());
    final maxId = ids.isEmpty ? 0 : ids.reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _addItem() {
    final name = _nameCtl.text.trim();
    final note = _noteCtl.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _items.insert(0, {
        'id': _nextId(),
        'name': name,
        'note': note,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _nameCtl.clear();
      _noteCtl.clear();
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _storage.writeJsonList(_items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu JSON vào bộ nhớ máy.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Save & Load JSON (Local Storage)'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            tooltip: 'Save',
            icon: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
          ),
          IconButton(
            onPressed: _loading ? null : _load,
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameCtl,
                        decoration: const InputDecoration(
                          labelText: 'Tên item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteCtl,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú (tuỳ chọn)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Add item (chưa lưu)'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có dữ liệu. Thử Add item rồi bấm Save.',
                          ),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final it = _items[index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text('${it['id'] ?? '?'}'),
                              ),
                              title: Text((it['name'] ?? '').toString()),
                              subtitle: Text((it['note'] ?? '').toString()),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }
}

