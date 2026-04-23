import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({required this.currentPassword, required this.newPassword});
}

class ChangePasswordUseCase implements UseCase<Unit, ChangePasswordParams> {
  final IAuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ChangePasswordParams params) {
    return repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
