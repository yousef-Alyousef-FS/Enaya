import 'package:equatable/equatable.dart';

import '../../../../appointments/domain/entities/appointment_entity.dart';

class ReceptionDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<AppointmentEntity> todayAppointments;
  final List<AppointmentEntity> waitingList;
  final bool isReceptionist;

  const ReceptionDashboardState({
    required this.isLoading,
    required this.errorMessage,
    required this.todayAppointments,
    required this.waitingList,
    required this.isReceptionist,
  });

  factory ReceptionDashboardState.initial({required bool isReceptionist}) {
    return ReceptionDashboardState(
      isLoading: false,
      errorMessage: null,
      todayAppointments: const [],
      waitingList: const [],
      isReceptionist: isReceptionist,
    );
  }

  bool get isError => errorMessage != null;

  ReceptionDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    List<AppointmentEntity>? todayAppointments,
    List<AppointmentEntity>? waitingList,
    bool? isReceptionist,
  }) {
    return ReceptionDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      waitingList: waitingList ?? this.waitingList,
      isReceptionist: isReceptionist ?? this.isReceptionist,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    todayAppointments,
    waitingList,
    isReceptionist,
  ];
}
