import 'package:flutter/material.dart';
import 'package:flutterpad/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Image.asset(
            'assets/google-logo.png',
            height: 30,
          ),
          label: const Text(
            'Sign In with Google',
            style: TextStyle(color: colorBlack, fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 70),
            backgroundColor: colorWhite,
          ),
        ),
      ),
    );
  }
}
