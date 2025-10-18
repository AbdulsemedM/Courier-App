// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/login/data/data_provider/login_data_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginRepository {
  final LoginDataProvider loginDataProvider;
  // final UserManager userManager;
  LoginRepository(this.loginDataProvider);

  Future<String> sendLogin(String email, String password) async {
    final authService = AuthService();
    try {
      // print("here we gooooo");
      final loginData = await loginDataProvider.sendLogin(email, password);

      final data = jsonDecode(loginData);
      if (data['status'] != 200) {
        // Log the message if needed
        // print('Error Message: ${data['message']}');

        // Throw only the message part
        throw data['message'];
      }

      // Store the token if the login is successful
      await authService.storeToken(data['token']);

      await authService.storeUserId(data['userId'].toString());
      Map<String, dynamic> decodedToken = JwtDecoder.decode(data['token']);
      await authService.storeBranch(decodedToken['user']['branch'].toString());
      await authService.storeRoleId(decodedToken['user']['role']);
      final permissions =
          await loginDataProvider.getPermissions(decodedToken['user']['role']);
      await PermissionManager().setPermission(
          permissions.permissions?.map((e) => e.name ?? '').toList() ?? []);
      return data['message'];
    } catch (e) {
      // Print and re-throw the exception for the message only
      // print('Caught Exception: $e');
      rethrow; // This will throw only the `message` part if thrown from above
    }
  }
}
