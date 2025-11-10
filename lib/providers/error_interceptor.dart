// error_interceptor.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorInterceptor {
  void checkError(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        // Try to parse the response body as JSON
        final data = jsonDecode(response.body);
        // Extract only the message from the API response
        final message = data['message'] ?? response.body;
        throw Exception(message);
      } catch (e) {
        // If parsing fails, throw the original body
        throw Exception(response.body);
      }
    }
  }
}
