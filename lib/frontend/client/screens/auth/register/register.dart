import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/widgets/auth/auth_text_field.dart';
import 'package:shop_aura/frontend/client/widgets/auth/button.dart';
import 'package:shop_aura/frontend/client/screens/auth/login/login.dart';

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
  bool _isLoading =false;
  // Map<String,dynamic>? Pagedata;
  Future<void> _handleRegister()async{
    if(!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });    
    await Future.delayed(
      const Duration(seconds: 2)
    );
    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful"))
    );


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
                          border: Border.all(color: Colors.black),
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
                              Container(
                                height: 58,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.phone_outlined,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 5),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: "+91",
                                        borderRadius: BorderRadius.circular(12),
                                        items: [
                                          DropdownMenuItem(
                                            value: "+91",
                                            child: Text("+91"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          if (value == null) return;
                                        },
                                      ),
                                    ),
                                    Container(
                                      // margin: EdgeInsets.symmetric(horizontal: 10),
                                      height: 20,
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 3),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          // isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          filled: true,
                                          fillColor: AppColors.background,
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Phone number is required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
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
                                  if (v == null || v.isEmpty)return "Confirm password is required";
                                  if (v != _passwordController.text)return "Password Not Matching";
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
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              GradientButton(
                                label: "Sign up",
                                isLoading: _isLoading,
                                onPressed:_handleRegister,
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
                              SizedBox(height: 15,),
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
