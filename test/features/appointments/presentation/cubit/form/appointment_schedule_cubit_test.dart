import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/features/appointments/domain/entities/doctor_summary.dart';
import 'package:enaya/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/generate_time_slots_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_available_doctors_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/reschedule_appointment_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/search_available_slots_usecase.dart';
import 'package:enaya/features/appointments/presentation/cubit/form/appointment_schedule_cubit.dart';
import 'package:enaya/core/usecases/usecase.dart';

class MockGetAvailableDoctorsUseCase extends Mock
    implements GetAvailableDoctorsUseCase {}

class MockCreateAppointmentUseCase extends Mock
    implements CreateAppointmentUseCase {}

class MockGenerateTimeSlotsUseCase extends Mock
    implements GenerateTimeSlotsUseCase {}

class MockSearchAvailableSlotsUseCase extends Mock
    implements SearchAvailableSlotsUseCase {}

class MockRescheduleAppointmentUseCase extends Mock
    implements RescheduleAppointmentUseCase {}

void main() {
  group('AppointmentScheduleCubit', () {
    late MockGetAvailableDoctorsUseCase getAvailableDoctorsUseCase;
    late MockCreateAppointmentUseCase createAppointmentUseCase;
    late MockGenerateTimeSlotsUseCase generateTimeSlotsUseCase;
    late MockSearchAvailableSlotsUseCase searchAvailableSlotsUseCase;
    late MockRescheduleAppointmentUseCase rescheduleAppointmentUseCase;

    setUp(() {
      getAvailableDoctorsUseCase = MockGetAvailableDoctorsUseCase();
      createAppointmentUseCase = MockCreateAppointmentUseCase();
      generateTimeSlotsUseCase = MockGenerateTimeSlotsUseCase();
      searchAvailableSlotsUseCase = MockSearchAvailableSlotsUseCase();
      rescheduleAppointmentUseCase = MockRescheduleAppointmentUseCase();
    });

    setUpAll(() {
      registerFallbackValue(NoParams());
    });

    test('loadAvailableDoctors stores the available doctors list', () async {
      const expectedDoctors = [
        DoctorSummary(id: 'd1', name: 'Dr. Samir'),
        DoctorSummary(id: 'd2', name: 'Dr. Laila'),
      ];

      when(
        () => getAvailableDoctorsUseCase.call(any()),
      ).thenAnswer((_) async => const Right(expectedDoctors));

      final cubit = AppointmentScheduleCubit(
        getAvailableDoctorsUseCase: getAvailableDoctorsUseCase,
        createAppointmentUseCase: createAppointmentUseCase,
        generateTimeSlotsUseCase: generateTimeSlotsUseCase,
        searchAvailableSlotsUseCase: searchAvailableSlotsUseCase,
        rescheduleAppointmentUseCase: rescheduleAppointmentUseCase,
      );

      await cubit.loadAvailableDoctors();

      expect(cubit.state.isDoctorsLoading, isFalse);
      expect(cubit.state.availableDoctors, expectedDoctors);
      expect(cubit.state.availableDoctors.first.id, 'd1');
    });
  });
}
