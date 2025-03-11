import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({super.key});

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Form data
  final Map<String, dynamic> formData = {
    'receiverBranch': null,
    'receiverMobile': '',
    'receiverName': '',
    'senderMobile': '',
    'senderName': '',
    'senderBranch': null,
  };

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStepIndicator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? (isDarkMode ? Colors.blue[400] : Colors.blue)
                    : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1931) : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A1931).withOpacity(0.95)
            : Colors.white.withOpacity(0.8),
        title: Text(
          'Add Shipment',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () {
            if (_currentPage == 0) {
              Navigator.pop(context);
            } else {
              _previousPage();
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(isDarkMode),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  FirstPage(
                    formData: formData,
                    onNext: _nextPage,
                  ),
                  SecondPage(
                    formData: formData,
                    onNext: _nextPage,
                    onPrevious: _previousPage,
                  ),
                  ThirdPage(
                    formData: formData,
                    onPrevious: _previousPage,
                    onSubmit: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Submit form data
                        print(formData);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
