import 'package:e_learning/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? profilePhoto;
  final String? token;
  final String? refreshToken;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.profilePhoto,
    this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: json['role'] as String? ?? 'student',
      profilePhoto: json['profilePhoto'] as String?,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'profilePhoto': profilePhoto,
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  User toEntity() {
    UserRole userRole;
    switch (role.toLowerCase()) {
      case 'instructor':
        userRole = UserRole.instructor;
        break;
      case 'admin':
        userRole = UserRole.admin;
        break;
      case 'student':
      default:
        userRole = UserRole.student;
        break;
    }

    return User(
      id: id,
      email: email,
      fullName: fullName,
      role: userRole,
      profilePhoto: profilePhoto,
      token: token,
      refreshToken: refreshToken,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role.name,
      profilePhoto: user.profilePhoto,
      token: user.token,
      refreshToken: user.refreshToken,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? profilePhoto,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
