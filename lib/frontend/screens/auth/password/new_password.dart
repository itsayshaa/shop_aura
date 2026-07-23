import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/screens/widgets/auth/button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _newPasswordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? _errorMessage;
  Future<void> _resetPassword()async{

    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
    return;
  }
  final newPassword = _newPasswordController.text.trim();
  setState(() {
    _isLoading =  true;
    _errorMessage = null;
  });

  try{
    final url = dotenv.env["API_URL"];
    if(url == null || url.isEmpty){
      throw Exception("API url is missing");
    }
    final response = await http.post(
      Uri.parse("$url/changepassword"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
      "email": widget.email,
      "newPassword": newPassword
      })  
    );
    if(response.statusCode  != 200){
      throw Exception(
        "server Error: ${response.statusCode} - ${response.body}"
      );
    }
    final data = jsonDecode(response.body);
    if(data["success"] != true){
      throw Exception(
        data["message"] ?? "Failed to chane password"
      );
    }
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data["message"] ?? "Password changed successfuly"),
      )
    );
    await Future.delayed(
      const Duration(seconds: 1)
    );
    if(!mounted) return;
    Navigator.popUntil(
      context,
      (route) => route.isFirst
    );

  }catch(e){
    if(!mounted) return;
    setState(() {
      _errorMessage = e.toString().replaceFirst("Exception: ", '');
    });
  }finally{
    if(mounted){
      setState(() {
        _isLoading = false;
      });
    }
  }
  }
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),

            child: Container(
              width: 430,

              padding: const EdgeInsets.fromLTRB(
                28,
                24,
                28,
                28,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.08),
                    blurRadius: 25,
                    offset:
                        const Offset(0, 8),
                  ),
                ],
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // Back Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: const [

                          Icon(
                            Icons
                                .arrow_back_ios_new_rounded,
                            size: 16,
                            color:
                                Color(0xFF555555),
                          ),

                          SizedBox(width: 8),

                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Color(0xFF555555),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 38),

                    // Title
                    const Center(
                      child: Text(
                        'Reset Password',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF292929),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Description
                    const Center(
                      child: Text(
                        'Create a new password for your account. Make sure your password is strong and secure.',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color:
                              Color(0xFF666666),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),

                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 18,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFFFF1F1,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(8),

                          border:
                              Border.all(
                            color:
                                const Color(
                              0xFFFFD6D6,
                            ),
                          ),
                        ),

                        child: Text(
                          _errorMessage!,

                          textAlign:
                              TextAlign.center,

                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFF9B4040,
                            ),
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),

                    // New Password Label
                    const Text(
                      'New Password',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // New Password Field
                    TextFormField(
                      controller:
                          _newPasswordController,

                      obscureText:
                          _obscureNewPassword,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please enter a new password';
                        }

                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        return null;
                      },

                      decoration:
                          InputDecoration(
                        hintText:
                            'Enter your new password',

                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                        ),

                        suffixIcon:
                            IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons
                                    .visibility_outlined,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscureNewPassword =
                                  !_obscureNewPassword;
                            });
                          },
                        ),

                        filled: true,

                        fillColor:
                            const Color(
                          0xFFF8F8F8,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              BorderSide.none,
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFFE5E5E5),
                          ),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFF292929),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password Label
                    const Text(
                      'Confirm Password',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Confirm Password Field
                    TextFormField(
                      controller:
                          _confirmPasswordController,

                      obscureText:
                          _obscureConfirmPassword,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value !=
                            _newPasswordController
                                .text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },

                      decoration:
                          InputDecoration(
                        hintText:
                            'Confirm your new password',

                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                        ),

                        suffixIcon:
                            IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons
                                    .visibility_off_outlined
                                : Icons
                                    .visibility_outlined,
                          ),

                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),

                        filled: true,

                        fillColor:
                            const Color(
                          0xFFF8F8F8,
                        ),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              BorderSide.none,
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFFE5E5E5),
                          ),
                        ),

                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(10),

                          borderSide:
                              const BorderSide(
                            color:
                                Color(0xFF292929),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Reset Password Button
                    SizedBox(
                      width:
                          double.infinity,

                      height: 56,

                      child:
                          GradientButton(
                        label:
                            'Reset Password',

                        isLoading:
                            _isLoading,

                        onPressed:
                            _isLoading
                                ? null
                                : _resetPassword,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Security Text
                    const Center(
                      child: Text(
                        'Your password will be securely updated.',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          fontSize: 13,
                          color:
                              Color(0xFF777777),
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