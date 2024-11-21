import 'package:courier_app/app/utils/app_themes.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
