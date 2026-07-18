import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/frontend/client/widgets/auth/auth_text_field.dart';
import 'package:shop_aura/frontend/client/widgets/auth/button.dart';
import 'package:shop_aura/frontend/client/screens/auth/register/register.dart';
import 'package:flutter_svg/flutter_svg.dart';
class LoginPage extends StatefulWidget{
@override
State<LoginPage> createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
   bool _isLoading = false;
  // Map<String,dynamic>? Pagedata;
  Future<void> _handleLogin()async{
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
  Widget build(BuildContext context){

    return PopScope(
      onPopInvokedWithResult: (didPop, result){
        FocusManager.instance.primaryFocus?.unfocus();
      } ,
      child:GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
    child:Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
      child:Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
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
                    border: Border.all(
                      color: Colors.black
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 12),
                        blurRadius: 40
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Login to continue shopping",
                          style: TextStyle(
                            color: Colors.grey.shade600
                          ),
                        ),
                        SizedBox(height: 15,),
                        AuthTextField(
                          hint: "Email Address",
                          icon:Icons.mail_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v){
                            if(v == null || v.isEmpty) return "Email is required";
                            if(!v.contains('@')) return 'Enter Valid Email';
                            return null;
                          },
                        ),
                        SizedBox(height: 15,),
                        AuthTextField(
                          hint: "Password",
                          icon:Icons.lock_outline,
                          controller: _passwordController,
                          isPassword: true,
                          validator: (v){
                            if(v == null || v.isEmpty) return "password is required";
                            if(v.length < 8) return "Minimum 8 character";
                            return null;
                          },
                        ),

                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: ()=> setState(() => _rememberMe = !_rememberMe),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: AppColors.primary,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (v)=> setState(()=> _rememberMe = v ?? false),
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: (){},
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.transparent
                              ),
                              child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15
                              ),
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      GradientButton(
                            label: "Sign In",
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),
                          SizedBox(height: 10,),
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
                                "Don't have an account?",
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> RegisterPage()),),
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor: Colors.transparent
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        ),
      )
    )
    )
    );
  }
}