import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AuthTextField extends StatefulWidget{
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

 const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType  = TextInputType.text,
    this.validator,
    this.onChanged
  });

  @override
  State<AuthTextField> createState() => _AuthTextField();
}

class _AuthTextField extends State<AuthTextField>{
  bool _obscure = true;
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState(){
    super.initState();
    _passwordFocus.addListener((){
      setState(() {
      });
    });
  }
  @override
  void dispose(){
    _passwordFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(left: 4,right: 8),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.isPassword ? _passwordFocus : null,
          obscureText: widget.isPassword ? _obscure:false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            filled: true,
            fillColor: AppColors.background,
            hintText: widget.hint,
            prefixIcon: Icon(
              widget.icon,
              color: Colors.black,
            ),
            suffixIcon: widget.isPassword && _passwordFocus.hasFocus
        ? IconButton(
            icon: Icon(
              color:Colors.grey.shade600,
              _obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          )
        : null,
          ),
        )
      ],
    );
  }
}