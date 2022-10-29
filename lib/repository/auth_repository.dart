import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpad/constants.dart';
import 'package:flutterpad/repository/models/error_model.dart';
import 'package:flutterpad/repository/models/local_storage_repository.dart';
import 'package:flutterpad/repository/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Provier for Google Authentication
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);

// Provider for user model object
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

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
          name: user.displayName ?? '',
          email: user.email,
          profilePicture: user.photoUrl ?? '',
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
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            // Save the JWT to the device's local storage
            _localStorageRepository.setToken(newUser.token);
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

  // Asynchronous call to retriee user data
  Future<ErrorModel> getUserData() async {
    // Initialise error model to be returned
    ErrorModel error = ErrorModel(
      error: "An unexpected error occurred",
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      // Case when user already has a JWT
      if (token != null) {
        var res = await _client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });
        switch (res.statusCode) {
          case 200:
            // Retrieve the user from the response, and append a token
            final newUser =
                UserModel.fromJson(jsonEncode(jsonDecode(res.body)['user']))
                    .copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            // Save the JWT to the device's local storage
            _localStorageRepository.setToken(newUser.token);
            break;
          default:
            break;
        }
      }
      // Check status code of request and dynamically respond
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  // Sign the user out by removing the authentication token
  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}
