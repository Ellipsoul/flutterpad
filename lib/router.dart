import 'package:flutter/material.dart';
import 'package:flutterpad/screens/document_screen.dart';
import 'package:flutterpad/screens/home_screen.dart';
import 'package:flutterpad/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

// Available routes when a user is logged out
final loggedOutRoute = RouteMap(routes: {
  '/': (router) => const MaterialPage(child: LoginScreen()),
});

// Available routes when a user is logged in
final loggedInRoute = RouteMap(routes: {
  '/': (router) => const MaterialPage(child: HomeScreen()),
  // Dynamically generated route
  '/document/:id': (router) => MaterialPage(
        child: DocumentScreen(id: router.pathParameters['id']!),
      )
});
