import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/colors.dart';
import 'package:flutterpad/repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
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
