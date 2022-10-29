import 'package:flutter/material.dart';
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
  // Add a document screen here eventually
});
