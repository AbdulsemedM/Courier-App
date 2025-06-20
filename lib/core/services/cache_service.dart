import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static const Duration cacheValidity = Duration(days: 1);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.json');
  }

  Future<void> saveData(String key, dynamic data) async {
    try {
      final file = await _getFile(key);
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'data': data,
      };
      await file.writeAsString(jsonEncode(cacheData));
    } catch (e) {
      print('Error saving cache for $key: $e');
    }
  }

  Future<dynamic> getData(String key) async {
    try {
      final file = await _getFile(key);
      if (!await file.exists()) {
        return null;
      }

      final contents = await file.readAsString();
      final cacheData = jsonDecode(contents);
      final timestamp = DateTime.parse(cacheData['timestamp']);

      // Check if cache is still valid (not older than cacheValidity)
      if (DateTime.now().difference(timestamp) > cacheValidity) {
        await file.delete();
        return null;
      }

      return cacheData['data'];
    } catch (e) {
      print('Error reading cache for $key: $e');
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    try {
      final file = await _getFile(key);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error clearing cache for $key: $e');
    }
  }

  Future<void> clearAllCache() async {
    try {
      final path = await _localPath;
      final directory = Directory(path);
      await for (var entity in directory.list()) {
        if (entity is File && entity.path.endsWith('.json')) {
          await entity.delete();
        }
      }
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }
}
