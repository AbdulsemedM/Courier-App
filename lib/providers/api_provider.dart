// api_provider.dart
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:courier_app/configuration/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

class ApiProvider {
  // final String baseUrl;
  final AuthInterceptor authInterceptor;
  final ErrorInterceptor errorInterceptor;
  final LoggingInterceptor loggingInterceptor;
  final Duration timeout;

  ApiProvider({
    // required this.baseUrl,
    required this.authInterceptor,
    required this.errorInterceptor,
    required this.loggingInterceptor,
    this.timeout = const Duration(seconds: 30),
  });

  Future<http.Response> getRequest(String endpoint,
      {Map<String, dynamic>? params}) async {
    var url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    if (params != null && params.isNotEmpty) {
      url = url.replace(
          queryParameters:
              params.map((key, value) => MapEntry(key, value.toString())));
    }
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http.get(url, headers: headers).timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      loggingInterceptor.logRequest(url.toString(), 'GET', headers, null);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> postRequest(
      String endpoint, Map<dynamic, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      loggingInterceptor.logRequest(url.toString(), 'POST', headers, body);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> putRequest(
      String endpoint, Map<dynamic, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();

    try {
      final response = await http
          .put(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      loggingInterceptor.logRequest(url.toString(), 'PUT', headers, body);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }

  Future<http.Response> postMultipartRequest(
      String endpoint, Map<String, String> fields, File? file, String fileFieldName) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await authInterceptor.getHeaders();
    
    // Remove Content-Type from headers as multipart will set it
    final multipartHeaders = Map<String, String>.from(headers);
    multipartHeaders.remove('Content-Type');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(multipartHeaders);
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add file if provided
      if (file != null && await file.exists()) {
        final fileStream = http.ByteStream(file.openRead());
        final fileLength = await file.length();
        final multipartFile = http.MultipartFile(
          fileFieldName,
          fileStream,
          fileLength,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      loggingInterceptor.logRequest(url.toString(), 'POST', multipartHeaders, fields);
      loggingInterceptor.logResponse(response);
      errorInterceptor.checkError(response);
      return response;
    } catch (error) {
      loggingInterceptor.logError(error);
      rethrow;
    }
  }
}
