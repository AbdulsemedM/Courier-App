// error_interceptor.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorInterceptor {
  void checkError(http.Response response) {
    if (response.statusCode < 400) return;

    Map<String, dynamic>? jsonMap;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        jsonMap = decoded;
      }
    } on FormatException {
      // Body is not JSON; fall through to plain-text / fallback handling.
    }

    if (jsonMap != null) {
      throw Exception(_messageFromErrorJson(jsonMap, response.statusCode));
    }

    final body = response.body.trim();
    if (body.isNotEmpty) {
      throw Exception(body);
    }
    throw Exception(_statusFallbackMessage(response.statusCode));
  }

  String _messageFromErrorJson(Map<String, dynamic> data, int statusCode) {
    final direct = data['message'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString();
    }

    final error = data['error']?.toString();

    switch (statusCode) {
      case 401:
        return error != null && error.isNotEmpty
            ? '$error. Please sign in again.'
            : 'Your session has expired. Please sign in again.';
      case 403:
        final base = error != null && error.isNotEmpty
            ? error
            : 'Access denied';
        return '$base. You don\'t have permission to view this. '
            'Ask an administrator if you need analytics access.';
      case 404:
        return error != null && error.isNotEmpty
            ? '$error. The requested resource was not found.'
            : 'The requested resource was not found.';
      case 408:
      case 504:
        return 'The server took too long to respond. Try again in a moment.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      default:
        if (statusCode >= 500) {
          return error != null && error.isNotEmpty
              ? '$error. Please try again later.'
              : 'Something went wrong on the server. Please try again later.';
        }
        if (error != null && error.isNotEmpty) {
          return '$error (HTTP $statusCode).';
        }
        return _statusFallbackMessage(statusCode);
    }
  }

  String _statusFallbackMessage(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'Unauthorized. Please sign in again.';
      case 403:
        return 'Access denied. You don\'t have permission to view this data.';
      case 404:
        return 'Not found.';
      case 408:
      case 504:
        return 'Request timed out. Check your connection and try again.';
      case 429:
        return 'Too many requests. Please wait and try again.';
      default:
        if (statusCode >= 500) {
          return 'Server error ($statusCode). Please try again later.';
        }
        return 'Request failed (HTTP $statusCode).';
    }
  }
}
