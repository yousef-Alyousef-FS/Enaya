import 'package:equatable/equatable.dart';

class ForgotPasswordEntity extends Equatable {
  final bool success;
  final String message;

  const ForgotPasswordEntity({
    required this.success,
    required this.message,
  });

  @override
  List<Object?> get props => [success, message];
}
