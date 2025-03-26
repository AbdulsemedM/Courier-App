import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A237E),
                    const Color(0xFF0D47A1),
                  ]
                : [
                    const Color(0xFFE3F2FD),
                    const Color(0xFFBBDEFB),
                  ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rocket Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Lottie.asset(
                  'assets/animations/rocket.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              // Coming Soon Text with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDarkMode
                      ? [Colors.white, Colors.blue.shade200]
                      : [Colors.blue.shade700, Colors.blue.shade900],
                ).createShader(bounds),
                child: const Text(
                  'Coming Soon!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'We\'re working hard to bring you\nsomething amazing!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Feature Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.engineering_outlined,
                      size: 48,
                      color: isDarkMode ? Colors.white70 : Colors.blue.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Feature Under Development',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Our team is working diligently to bring you this exciting new feature. Stay tuned for updates!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Return Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.blue.shade700 : Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
