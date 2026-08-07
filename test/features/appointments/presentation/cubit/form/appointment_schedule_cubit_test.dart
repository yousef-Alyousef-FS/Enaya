import 'package:dartz/dartz.dart';
import 'package:enaya/core/usecases/usecase.dart';
import 'package:enaya/core/usecases/usecase.dart';
import 'package:enaya/features/appointments/domain/entities/doctor_summary.dart';
import 'package:enaya/features/appointments/domain/usecases/create_appointment_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/generate_time_slots_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/get_available_doctors_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/reschedule_appointment_usecase.dart';
import 'package:enaya/features/appointments/domain/usecases/search_available_slots_usecase.dart';
import 'package:enaya/features/appointments/presentation/cubit/form/appointment_schedule_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktailation/cubit/form/appointment_schedule_cubit.dart';

class MockGetAvailableDoctorsUseCase extends Mock
    implements GetAvailableDoctorsUseCase {}

class MockCreateAppointmentUseCase extends Mock
    implements CreateAppointmentUseCase {}

class MockSearchAvailableSlotsUseCase extends Mock
    implements SearchAvailableSlotsUseCase {}

class MockRescheduleAppointmentUseCase extends Mock
    implements RescheduleAppointmentUseCase {}

class MockGetAvailableDaysUseCase extends Mock
    implements GetAvailableDaysUseCase {}

class MockGetAvailableSlotsUseCase extends Mock
    implements GetAvailableSlotsUseCase {}

void main() {
  group('AppointmentScheduleCubit', () {
    late MockGetAvailableDoctorsUseCase getAvailableDoctorsUseCase;
    late MockCreateAppointmentUseCase createAppointmentUseCase;
    late MockSearchAvailableSlotsUseCase searchAvailableSlotsUseCase;
    late MockRescheduleAppointmentUseCase rescheduleAppointmentUseCase;
    late MockGetAvailableDaysUseCase getAvailableDaysUseCase;
    late MockGetAvailableSlotsUseCase getAvailableSlotsUseCase;

    setUp(() {
      getAvailableDoctorsUseCase = MockGetAvailableDoctorsUseCase();
      createAppointmentUseCase = MockCreateAppointmentUseCase();
      searchAvailableSlotsUseCase = MockSearchAvailableSlotsUseCase();
      rescheduleAppointmentUseCase = MockRescheduleAppointmentUseCase();
      getAvailableDaysUseCase = MockGetAvailableDaysUseCase();
      getAvailableSlotsUseCase = MockGetAvailableSlotsUseCase();
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
        searchAvailableSlotsUseCase: searchAvailableSlotsUseCase,
        rescheduleAppointmentUseCase: rescheduleAppointmentUseCase,
        getAvailableDaysUseCase: getAvailableDaysUseCase,
        getAvailableSlotsUseCase: getAvailableSlotsUseCase,
      );

      await cubit.loadAvailableDoctors();

      expect(cubit.state.isDoctorsLoading, isFalse);
      expect(cubit.state.availableDoctors, expectedDoctors);
      expect(cubit.state.availableDoctors.first.id, 'd1');
    });
  });
}
