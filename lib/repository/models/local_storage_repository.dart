import "package:shared_preferences/shared_preferences.dart";

// Handles local storage of user's JWT
class LocalStorageRepository {
  void setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('x-auth-token');
    return token;
  }
}
