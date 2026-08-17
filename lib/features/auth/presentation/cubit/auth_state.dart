import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Immutable auth UI state.
class AuthState extends Equatable {
  final bool isLoading;

  /// Last user-facing error message, if any.
  final String? errorMessage;

  /// Operation success flag for one-shot UI feedback.
  final bool isSuccess;

  /// Flag indicating if the last error was network-related.
  final bool isNetworkError;

  /// Authenticated user payload when logged in.
  final UserEntity? currentUser;

  const AuthState({
    required this.isLoading,
    required this.errorMessage,
    required this.isSuccess,
    required this.isNetworkError,
    required this.currentUser,
  });

  const AuthState.initial()
    : isLoading = false,
      errorMessage = null,
      isSuccess = false,
      isNetworkError = false,
      currentUser = null;

  /// `true` when state holds an error message.
  bool get isError => errorMessage != null;

  /// `true` when there is an active authenticated user.
  bool get isLoggedIn => currentUser != null;

  /// Returns updated state with clear flags for nullable fields.
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSuccess,
    bool? isNetworkError,
    UserEntity? currentUser,
    bool clearCurrentUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isNetworkError: isNetworkError ?? this.isNetworkError,
      currentUser: clearCurrentUser ? null : currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    isSuccess,
    isNetworkError,
    currentUser,
  ];
}
