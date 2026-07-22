import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/widgets/auth/button.dart';
import 'new_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  String get _otp {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {
      _errorMessage = null;
    });
  }


  Future<String> _verifyOtpApi({
    required String email,
    required String otp
  })async{
    final url = dotenv.env["API_URL"];
    if(url == null || url.isEmpty){
      throw Exception("Api url is missing");
    }
    final response = await http.post(
      Uri.parse("$url/verify-otp"),
      body: jsonEncode({
        "email":email,
        "otp":otp
      })
    );

    final data = jsonDecode(response.body);
    if(response.statusCode == 200 && data["success"] == true){
        return data["message"] ?? "OTP verified success";
    }
    throw Exception(
      data["message"] ?? "Invalid or Expired OTP"
    );
  }


  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _otp;

    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final message = await _verifyOtpApi(email: widget.email, otp: otp);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(message)),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP sent again')));
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
                            'Back',
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

                    const Center(
                      child: Text(
                        'Verify OTP',

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

                    Center(
                      child: Text(
                        'We have sent a 6-digit verification code to',

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Center(
                      child: Text(
                        widget.email,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF292929),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

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

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            color: Color(0xFF9B4040),

                            fontSize: 13,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          height: 55,

                          child: TextFormField(
                            controller: _otpControllers[index],

                            focusNode: _focusNodes[index],

                            keyboardType: TextInputType.number,

                            textAlign: TextAlign.center,

                            maxLength: 1,

                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF292929),
                            ),

                            decoration: InputDecoration(
                              counterText: '',

                              filled: true,

                              fillColor: const Color(0xFFF8F8F8),

                              contentPadding: EdgeInsets.zero,

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),

                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),

                                borderSide: const BorderSide(
                                  color: Color(0xFF292929),

                                  width: 1.5,
                                ),
                              ),
                            ),

                            onChanged: (value) {
                              _onOtpChanged(value, index);
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,

                      height: 56,

                      child: GradientButton(
                        label: 'Verify OTP',

                        isLoading: _isLoading,

                        onPressed: _isLoading ? null : _verifyOtp,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text(
                            "Didn't receive the code? ",

                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF777777),
                            ),
                          ),

                          GestureDetector(
                            onTap: _resendOtp,

                            child: const Text(
                              'Resend OTP',

                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF292634),
                                fontWeight: FontWeight.w600,
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
    );
  }
}
