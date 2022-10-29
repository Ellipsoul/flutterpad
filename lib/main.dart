import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/repository/auth_repository.dart';
import 'package:flutterpad/router.dart';
import 'package:routemaster/routemaster.dart';

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
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Assigns available route depending on user's logged in state
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        } else {
          return loggedOutRoute;
        }
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
