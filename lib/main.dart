import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/repository/auth_repository.dart';
import 'package:flutterpad/screens/home_screen.dart';
import 'package:flutterpad/screens/login_screen.dart';

import 'repository/models/error_model.dart';

void main() {
  runApp(
    // Stores the state of all providers in the app
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel; // Track the state of the user authentication

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Conditionally render the home screen once the user has logged in
      home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
