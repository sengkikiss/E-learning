enum UserRole {
  student,
  instructor,
  admin,
}

class User {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? profilePhoto;
  final String? token;
  final String? refreshToken;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.profilePhoto,
    this.token,
    this.refreshToken,
  });

  bool get isStudent => role == UserRole.student;
  bool get isInstructor => role == UserRole.instructor;
  bool get isAdmin => role == UserRole.admin;

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    UserRole? role,
    String? profilePhoto,
    String? token,
    String? refreshToken,
  }) {
    return User(
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
