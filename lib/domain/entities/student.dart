class Student {
  final String id;
  final String studentId;
  final String fullName;
  final String gender;
  final String dateOfBirth;
  final String phoneNumber;
  final String email;
  final String profilePhoto;
  final String educationLevel;
  final String accountStatus;

  const Student({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.profilePhoto,
    required this.educationLevel,
    required this.accountStatus,
  });

  Student copyWith({
    String? id,
    String? studentId,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? phoneNumber,
    String? email,
    String? profilePhoto,
    String? educationLevel,
    String? accountStatus,
  }) {
    return Student(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      educationLevel: educationLevel ?? this.educationLevel,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }
}
