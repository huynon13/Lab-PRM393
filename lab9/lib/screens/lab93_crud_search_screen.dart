import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/json_storage.dart';

class Lab93CrudSearchScreen extends StatefulWidget {
  const Lab93CrudSearchScreen({super.key});

  @override
  State<Lab93CrudSearchScreen> createState() => _Lab93CrudSearchScreenState();
}

class _Lab93CrudSearchScreenState extends State<Lab93CrudSearchScreen> {
  final _storage = const JsonStorage(fileName: 'lab93_db.json');

  bool _loading = true;
  String _query = '';

  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final raw = await _storage.readJsonListOrEmpty();
    final items = raw
        .whereType<Map>()
        .map((e) => Item.fromJson(e.cast<String, dynamic>()))
        .toList();
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  int _nextId() {
    final maxId =
        _items.isEmpty ? 0 : _items.map((e) => e.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  Future<void> _persist() async {
    await _storage.writeJsonList(_items.map((e) => e.toJson()).toList());
  }

  List<Item> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.id.toString().contains(q);
    }).toList();
  }

  Future<void> _openEditor({Item? existing}) async {
    final nameCtl = TextEditingController(text: existing?.name ?? '');
    final catCtl = TextEditingController(text: existing?.category ?? '');
    final priceCtl =
        TextEditingController(text: existing == null ? '' : existing.price.toString());

    final result = await showDialog<Item>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add item' : 'Edit item #${existing.id}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: catCtl,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameCtl.text.trim();
                final cat = catCtl.text.trim();
                final price = int.tryParse(priceCtl.text.trim()) ?? 0;
                if (name.isEmpty || cat.isEmpty) return;
                final item = (existing ?? Item(id: _nextId(), name: '', category: '', price: 0))
                    .copyWith(name: name, category: cat, price: price);
                Navigator.pop(context, item);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameCtl.dispose();
    catCtl.dispose();
    priceCtl.dispose();

    if (result == null) return;

    setState(() {
      final idx = _items.indexWhere((e) => e.id == result.id);
      if (idx >= 0) {
        _items[idx] = result;
      } else {
        _items.insert(0, result);
      }
    });
    await _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã auto-save JSON sau thay đổi.')),
    );
  }

  Future<void> _delete(Item item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá item?'),
        content: Text('Bạn có chắc muốn xoá "${item.name}" (id=${item.id}) không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _items.removeWhere((e) => e.id == item.id));
    await _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá và auto-save.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - JSON CRUD + Search (Auto-save)'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _load,
            tooltip: 'Reload from file',
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
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search (name/category/id)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Không có dữ liệu phù hợp.'))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final it = filtered[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text('${it.id}')),
                              title: Text(it.name),
                              subtitle: Text('Loại: ${it.category} • Giá: ${it.price}đ'),
                              onTap: () => _openEditor(existing: it),
                              trailing: IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _delete(it),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

