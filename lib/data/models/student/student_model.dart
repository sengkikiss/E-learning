import 'package:e_learning/domain/entities/student.dart';

class StudentModel {
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

  const StudentModel({
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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Not Specified',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String? ?? '',
      educationLevel: json['educationLevel'] as String? ?? 'Undergraduate',
      accountStatus: json['accountStatus'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'email': email,
      'profilePhoto': profilePhoto,
      'educationLevel': educationLevel,
      'accountStatus': accountStatus,
    };
  }

  Student toEntity() {
    return Student(
      id: id,
      studentId: studentId,
      fullName: fullName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      email: email,
      profilePhoto: profilePhoto,
      educationLevel: educationLevel,
      accountStatus: accountStatus,
    );
  }

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      studentId: student.studentId,
      fullName: student.fullName,
      gender: student.gender,
      dateOfBirth: student.dateOfBirth,
      phoneNumber: student.phoneNumber,
      email: student.email,
      profilePhoto: student.profilePhoto,
      educationLevel: student.educationLevel,
      accountStatus: student.accountStatus,
    );
  }
}
