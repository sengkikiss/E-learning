import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> execute(String email, String password) {
    return repository.login(email: email, password: password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> execute({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    return repository.register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> execute() {
    return repository.logout();
  }
}

class ChangePasswordUseCase {
  final AuthRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<void> execute({required String currentPassword, required String newPassword}) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
