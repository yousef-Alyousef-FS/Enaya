import 'package:equatable/equatable.dart';
import '../../domain/entities/base_profile_entity.dart';

/// Base class for all profile states.
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken.
class ProfileInitial extends ProfileState {}

/// Loading state while fetching profile data.
class ProfileLoading extends ProfileState {}

/// Success state when profile data is successfully fetched.
class ProfileLoaded extends ProfileState {
  final BaseProfileEntity profile;

  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Error state when fetching profile fails.
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when profile data is not available.
class ProfileNotAvailable extends ProfileState {
  final String message;

  ProfileNotAvailable(this.message);

  @override
  List<Object?> get props => [message];
}