import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/colors.dart';
import 'package:flutterpad/repository/auth_repository.dart';

import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Attempt to sign in with Google
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    // No error -> redirect to the home page
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      // Error signing in
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  // Simple sign in button for the login screen
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
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
