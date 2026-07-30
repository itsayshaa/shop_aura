import 'package:flutter/material.dart';

import 'package:shop_aura/frontend/user/screens/home_screen.dart';
import 'package:shop_aura/frontend/services/authService.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {

  @override
  void initState() {
    super.initState();

    checkUser();
  }

  Future<void> checkUser() async {
    final loggedIn = await Authservice.isLogged();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>  HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}