import 'dart:convert';

// Custom user model containing all properties in MongoDB and a refresh token
class UserModel {
  final String name;
  final String email;
  final String profilePicture;
  final String uid;
  final String token;
  UserModel(
      {required this.name,
      required this.email,
      required this.profilePicture,
      required this.uid,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'uid': uid,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      uid: map['_id'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePicture,
    String? uid,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}
