import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

class ManifestAwbLoader {
  static final RegExp _awbPattern = RegExp(r'^[A-Z]{2,}\d{3,}[A-Z0-9]*$');
  static final RegExp _sharedStringPattern = RegExp(r'<t[^>]*>([^<]+)</t>');

  static const Set<String> _excludedTokens = {
    'SENDER',
    'RECEIVER',
    'DESCRIPTION',
    'DESTINATION',
    'DOCUMENT',
    'WEIGHT',
    'VALUE',
    'QTY',
    'NO',
    'DATE',
    'BRANCH',
    'TOTAL',
    'PHONE',
    'NAME',
    'ADDRESS',
    'REMARKS',
    'KG',
    'ETB',
  };

  static Future<List<String>> loadFromDownloadUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download manifest file');
    }

    final archive = ZipDecoder().decodeBytes(response.bodyBytes);
    ArchiveFile? sharedStringsFile;
    for (final file in archive.files) {
      if (file.name == 'xl/sharedStrings.xml') {
        sharedStringsFile = file;
        break;
      }
    }

    if (sharedStringsFile == null) return const [];

    final xml = utf8.decode(sharedStringsFile.content as List<int>);
    final awbs = <String>[];
    for (final match in _sharedStringPattern.allMatches(xml)) {
      final token = match.group(1)?.trim().toUpperCase() ?? '';
      if (token.isEmpty || _excludedTokens.contains(token)) continue;
      if (_awbPattern.hasMatch(token)) {
        awbs.add(token);
      }
    }

    return awbs;
  }
}
