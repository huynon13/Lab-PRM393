import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Lưu 1 file JSON dạng List<Map> trong app documents directory.
class JsonStorage {
  final String fileName;

  const JsonStorage({required this.fileName});

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$fileName');
  }

  Future<List<dynamic>> readJsonListOrEmpty() async {
    final f = await _file();
    if (!await f.exists()) return <dynamic>[];
    final content = await f.readAsString();
    if (content.trim().isEmpty) return <dynamic>[];
    final decoded = jsonDecode(content);
    if (decoded is List) return decoded;
    return <dynamic>[];
  }

  Future<void> writeJsonList(List<dynamic> list) async {
    final f = await _file();
    await f.writeAsString(
      const JsonEncoder.withIndent('  ').convert(list),
      flush: true,
    );
  }
}
