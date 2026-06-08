import 'package:courier_app/app/utils/responsive_helper.dart';
import 'package:courier_app/core/services/remembered_credentials_vault.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:courier_app/features/forgot_password/presentation/screen/forgot_pass_screen.dart';
import 'package:courier_app/features/login/bloc/login_bloc.dart';
import 'package:courier_app/features/login/presentation/widgets/login_widgets.dart';
import 'package:courier_app/features/public_tracking/presentation/screens/public_tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final creds = await RememberedCredentialsVault().load();
    if (!mounted) return;
    if (creds != null) {
      _emailController.text = creds.email;
      _passwordController.text = creds.password;
      setState(() => _rememberMe = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openPublicTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PublicTrackingScreen()),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginFetched(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              rememberMe: _rememberMe,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final palette = context.palette;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: LoginWidgets.buildBackground(
          isDarkMode: isDarkMode,
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.isTablet(context) ? 440 : double.infinity,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      LoginWidgets.buildBrandHero(
                        isDarkMode: isDarkMode,
                        isDarkModeActive: isDarkMode,
                        onToggleTheme: themeProvider.toggleTheme,
                        onTrackShipment: _openPublicTracking,
                      ),
                      LoginWidgets.buildLoginCard(
                        isDarkMode: isDarkMode,
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        rememberMe: _rememberMe,
                        isLoading: _isLoading,
                        onTogglePassword: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        onRememberMeChanged: (value) {
                          setState(() => _rememberMe = value);
                        },
                        onLogin: _handleLogin,
                        onForgotPassword: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                      ),
                      LoginWidgets.buildPublicTrackPromoCard(
                        isDarkMode: isDarkMode,
                        onTap: _openPublicTracking,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        child: Text(
                          'HudHud Courier · v1.0.3',
                          style: TextStyle(
                            fontSize: 11,
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
