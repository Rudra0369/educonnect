import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    'student@educonnect.com': {
      'password': 'student123',
      'role': 'student',
      'name': 'Alex Johnson'
    },
    'teacher@educonnect.com': {
      'password': 'teacher123',
      'role': 'teacher',
      'name': 'Dr. Sarah Wilson'
    },
    'admin@educonnect.com': {
      'password': 'admin123',
      'role': 'admin',
      'name': 'Michael Chen'
    }
  };

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
      _isFormValid = _emailError == null &&
          _passwordError == null &&
          email.isNotEmpty &&
          password.isNotEmpty;
    });
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return null;

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return null;

    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Check mock credentials
      if (_mockCredentials.containsKey(email)) {
        final userCredentials = _mockCredentials[email]!;
        if (userCredentials['password'] == password) {
          // Success - trigger haptic feedback
          HapticFeedback.lightImpact();

          // Navigate based on role
          final role = userCredentials['role']!;
          if (role == 'student') {
            Navigator.pushReplacementNamed(context, '/student-dashboard');
          } else if (role == 'teacher') {
            Navigator.pushReplacementNamed(context, '/teacher-dashboard');
          } else {
            Navigator.pushReplacementNamed(context, '/student-dashboard');
          }
        } else {
          _showErrorMessage(
              'Invalid password. Please check your credentials and try again.');
        }
      } else {
        _showErrorMessage(
            'Account not found. Please check your email or sign up for a new account.');
      }
    } catch (e) {
      _showErrorMessage(
          'Network error. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate Google OAuth flow
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Simulate successful Google login
      HapticFeedback.lightImpact();
      Navigator.pushReplacementNamed(context, '/student-dashboard');
    } catch (e) {
      _showErrorMessage('Google sign-in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset functionality will be available soon. Please contact support for assistance.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Up',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Registration is currently available through our website. Please visit educonnect.com to create your account.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8.h),

                      // Header with logo and title
                      LoginHeaderWidget(),

                      SizedBox(height: 6.h),

                      // Login form
                      LoginFormWidget(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        isPasswordVisible: _isPasswordVisible,
                        isLoading: _isLoading,
                        isFormValid: _isFormValid,
                        emailError: _emailError,
                        passwordError: _passwordError,
                        onPasswordVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onLogin: _handleLogin,
                        onForgotPassword: _handleForgotPassword,
                      ),

                      SizedBox(height: 4.h),

                      // Social login
                      SocialLoginWidget(
                        isLoading: _isLoading,
                        onGoogleLogin: _handleGoogleLogin,
                      ),

                      const Spacer(),

                      // Sign up link
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New to learning? ',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: _isLoading ? null : _handleSignUp,
                              child: Text(
                                'Sign Up',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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
