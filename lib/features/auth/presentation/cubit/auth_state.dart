import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final UserEntity? currentUser;

  const AuthState({
    required this.isLoading,
    required this.errorMessage,
    required this.isSuccess,
    required this.currentUser,
  });

  const AuthState.initial()
    : isLoading = false,
      errorMessage = null,
      isSuccess = false,
      currentUser = null;

  bool get isError => errorMessage != null;
  bool get isLoggedIn => currentUser != null;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSuccess,
    UserEntity? currentUser,
    bool clearCurrentUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      currentUser: clearCurrentUser ? null : currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess, currentUser];
}
