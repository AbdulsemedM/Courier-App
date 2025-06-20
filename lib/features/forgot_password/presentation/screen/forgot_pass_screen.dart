import 'package:flutter/material.dart';
import '../widget/forgot_pass_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  void _handleForgotPassword(String? email, BuildContext? context) async {
    if (email == null || context == null || !context.mounted) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sending reset instructions...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset instructions sent to your email'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back after success
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 103, 21, 234),
              Color.fromARGB(255, 75, 23, 160),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ForgotPasswordWidget(
              onSubmit: (email) => _handleForgotPassword(email, context),
            ),
          ),
        ),
      ),
    );
  }
}
