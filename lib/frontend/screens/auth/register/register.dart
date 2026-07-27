import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_aura/frontend/screens/home_screen.dart';
import 'package:shop_aura/frontend/services/authService.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/screens/widgets/auth/auth_text_field.dart';
import 'package:shop_aura/frontend/screens/widgets/auth/button.dart';
import 'package:shop_aura/frontend/screens/auth/login/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isLoading = false;
  // Map<String,dynamic>? Pagedata;
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the Terms & Privacu Policy"),
        ),
      );
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final message = await Authservice.instance.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register Successful")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 12),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Register to start shopping with shopAura",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 15),
                              AuthTextField(
                                hint: "Full Name",
                                icon: Icons.person_outline,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                validator: (v) {
                                  if (v == null || v.isEmpty)return "Full name is required";
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              AuthTextField(
                                hint: "Email Address",
                                icon: Icons.mail_outline,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty)return "Email is required";
                                  if (!v.contains('@')) return 'Enter Valid Email';
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              FormField<String>(
                                validator: (value) {
                                  if (_phoneController.text.trim().isEmpty) {
                                    return "Phone number is required";
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 58,
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: field.hasError
                                                ? Colors.red
                                                : Colors.transparent,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 12),

                                            const Icon(
                                              Icons.phone_outlined,
                                              color: Colors.black,
                                            ),

                                            const SizedBox(width: 6),

                                            DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: "+91",
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: "+91",
                                                    child: Text("+91"),
                                                  ),
                                                ],
                                                onChanged: (value) {},
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            Container(
                                              height: 32,
                                              width: 1,
                                              color: Colors.grey,
                                            ),

                                            const SizedBox(width: 10),

                                            Expanded(
                                              child: TextField(
                                                controller: _phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                onChanged: (value) {
                                                  field.didChange(value);
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                      hintText: "Phone Number",
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      filled: false,
                                                      fillColor:
                                                          AppColors.white,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),
                                          ],
                                        ),
                                      ),

                                      // Error is now OUTSIDE the 58px container
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 14,
                                            top: 5,
                                          ),
                                          child: Text(
                                            field.errorText!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              AuthTextField(
                                hint: "Password",
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                isPassword: true,
                                validator: (v) {
                                  if (v == null || v.isEmpty)return "password is required";
                                  if (v.length < 8)return "Minimum 8 character";
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              AuthTextField(
                                hint: "Confirm Password",
                                icon: Icons.lock_outline,
                                controller: _confirmPasswordController,
                                isPassword: true,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return "Confirm password is required";
                                  if (v != _passwordController.text) return "Password Not Matching";
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              CheckboxListTile(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                visualDensity: VisualDensity(horizontal: -2),
                                horizontalTitleGap: 4,
                                title: Text(
                                  "I agree to the Terms & Conditions",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              GradientButton(
                                label: "Sign up",
                                isLoading: _isLoading,
                                onPressed: _handleRegister,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/google/google.svg',
                                    width: 22,
                                    height: 22,
                                  ),
                                  label: const Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Alrready have an account?",
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginPage(),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      overlayColor: Colors.transparent,
                                    ),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
