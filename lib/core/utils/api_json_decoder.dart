import 'dart:convert';

/// Decodes API JSON bodies, tolerating trailing garbage some endpoints append.
Map<String, dynamic> decodeApiMap(String body) {
  final trimmed = body.trim();
  if (trimmed.isEmpty) {
    throw const FormatException('Empty response body');
  }

  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw const FormatException('Expected a JSON object');
  } on FormatException {
    final extracted = _extractFirstJsonObject(trimmed);
    if (extracted != null) {
      final decoded = jsonDecode(extracted);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    rethrow;
  }
}

/// Parses objects from a `"data":[...]` array even when the full body is invalid.
List<Map<String, dynamic>> parseDataArrayLenient(
  String body, {
  String dataKey = 'data',
}) {
  final marker = '"$dataKey":[';
  final start = body.indexOf(marker);
  if (start < 0) return [];

  var index = start + marker.length;
  final items = <Map<String, dynamic>>[];

  while (index < body.length) {
    index = _skipWhitespaceAndCommas(body, index);
    if (index >= body.length) break;
    if (body[index] == ']') break;
    if (body[index] != '{') break;

    final end = _findMatchingBraceEnd(body, index);
    if (end == null) break;

    final segment = body.substring(index, end + 1);
    try {
      final decoded = jsonDecode(segment);
      if (decoded is Map) {
        items.add(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      // Skip malformed shipment object and continue.
    }

    index = end + 1;
  }

  return items;
}

String? _extractFirstJsonObject(String body) {
  final start = body.indexOf('{');
  if (start < 0) return null;

  final end = _findMatchingBraceEnd(body, start);
  if (end == null) return null;
  return body.substring(start, end + 1);
}

int _skipWhitespaceAndCommas(String body, int index) {
  while (index < body.length) {
    final ch = body[index];
    if (ch == ',' || ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t') {
      index++;
      continue;
    }
    break;
  }
  return index;
}

int? _findMatchingBraceEnd(String body, int start) {
  if (start >= body.length || body[start] != '{') return null;

  var depth = 0;
  var inString = false;
  var escape = false;

  for (var i = start; i < body.length; i++) {
    final ch = body[i];
    if (inString) {
      if (escape) {
        escape = false;
      } else if (ch == '\\') {
        escape = true;
      } else if (ch == '"') {
        inString = false;
      }
      continue;
    }

    if (ch == '"') {
      inString = true;
    } else if (ch == '{') {
      depth++;
    } else if (ch == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }

  return null;
}
