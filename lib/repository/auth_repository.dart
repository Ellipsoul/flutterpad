import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/constants.dart';
import 'package:flutterpad/repository/models/error_model.dart';
import 'package:flutterpad/repository/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Provier for Google Authentication
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);

// Provider for user model object
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  // Asynchronous Google Authentication
  Future<ErrorModel> signInWithGoogle() async {
    // Initialise error model to be returned
    ErrorModel error = ErrorModel(
      error: "An unexpected error occurred",
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        // Define user and post info to MongoDB
        final userAccount = UserModel(
          name: user.email,
          email: user.email,
          profilePicture: user.photoUrl!,
          uid: '',
          token: '',
        );

        var res = await _client.post(
          Uri.parse('$host/api/signup'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: userAccount.toJson(),
        );
        // Check status code of request and dynamically respond
        switch (res.statusCode) {
          case 200:
            final newUser = userAccount.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: '',
            );
            error = ErrorModel(error: null, data: newUser);
            break;
          default:
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }
}
