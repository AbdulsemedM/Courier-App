import 'package:flutter/material.dart';

class ForgotPasswordWidget extends StatefulWidget {
  final Function(String)? onSubmit;

  const ForgotPasswordWidget({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo and Title Section
            const Text(
              'HudHud express',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5A00), // Orange color from the image
              ),
            ),
            const SizedBox(height: 32),

            // Forgot Password Title with Lock Icon
            Row(
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.lock_outline,
                  color: Colors.white.withOpacity(0.8),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Instructions Text
            Text(
              'Enter your email, and we will send you instructions to reset your password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),

            // Email Label
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Email TextField
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                // filled: true,
                // fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  // borderSide: BorderSide.,
                ),
                hintText: 'Enter your email',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A00), // Teal color
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Back to Login Link
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFFF5A00), // Orange color
              ),
              label: const Text(
                'Back to login',
                style: TextStyle(
                  color: Color(0xFFFF5A00), // Orange color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
