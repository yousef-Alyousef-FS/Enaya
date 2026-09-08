import 'package:equatable/equatable.dart';

abstract class UpdateProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  UpdateProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
