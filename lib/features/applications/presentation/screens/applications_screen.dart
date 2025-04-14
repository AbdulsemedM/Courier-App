import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:courier_app/features/applications/presentation/widgets/application_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  void _handleOptionSelected(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 75, 23, 160)
          : const Color.fromARGB(255, 75, 23, 160),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Applications',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ApplicationWidgets.buildMenuGrid(
        isDarkMode: isDarkMode,
        options: defaultMenuOptions,
        onOptionSelected: (screen) => _handleOptionSelected(context, screen),
      ),
    );
  }
}
