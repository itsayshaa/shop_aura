import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/screens/auth/login/login.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/screens/widgets/auth/auth_text_field.dart';
import 'package:shop_aura/frontend/screens/widgets/auth/button.dart';
import 'package:http/http.dart' as http;
import 'verify_otp.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

Future<String> _sendResetLink({
  required String email,
}) async {
  try {

    final url = dotenv.env['API_URL'];

    if (url == null || url.isEmpty) {
      throw Exception('API URL is not configured');
    }

    final response = await http.post(
      Uri.parse('$url/forgotpassword'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data['message'] ?? 'OTP sent successfully';
    }

    throw Exception(
      data['message'] ?? 'Failed to send OTP',
    );  
  } catch (e) {
     print('Failed to send OTP: $e');
    rethrow;
  }
}

Future<void> _handleSendOtp() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    final message = await _sendResetLink(
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: _emailController.text.trim(),)));
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _errorMessage = e.toString().replaceFirst(
        'Exception: ',
        '',
      );
    });
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Container(
              width: 430,
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back to Home
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Color(0xFF555555),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 38),

                    // Title
                    const Center(
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF292929),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Description
                    const Center(
                      child: Text(
                        'Enter your registered email address below, and we will send you a secure link to reset your account password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFD6D6)),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFF9B4040),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Email Label
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Email Field
                    AuthTextField(
                      hint: "Enter Your Email Address",
                      controller: _emailController,
                      icon: Icons.mail_outline_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }

                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 22),

                    // Send Reset Link Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: GradientButton(
                        label: "Send Reset Link",
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _handleSendOtp,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Bottom Login Text
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF777777),
                          ),
                          children: [
                            const TextSpan(text: 'Remember your password? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Back to Login',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF292634),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
