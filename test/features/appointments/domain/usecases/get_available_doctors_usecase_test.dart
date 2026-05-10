import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:enaya/core/usecases/usecase.dart';
import 'package:enaya/features/appointments/domain/entities/doctor_summary.dart';
import 'package:enaya/features/appointments/domain/repositories/doctor_directory_repository.dart';
import 'package:enaya/features/appointments/domain/usecases/get_available_doctors_usecase.dart';

class MockDoctorDirectoryRepository extends Mock
    implements DoctorDirectoryRepository {}

void main() {
  group('GetAvailableDoctorsUseCase', () {
    late MockDoctorDirectoryRepository repository;

    setUp(() {
      repository = MockDoctorDirectoryRepository();
    });

    test('forwards the available doctors result', () async {
      const expectedDoctors = [
        DoctorSummary(id: 'd1', name: 'Dr. Samir'),
        DoctorSummary(id: 'd2', name: 'Dr. Laila'),
      ];

      when(
        () => repository.getDoctors(),
      ).thenAnswer((_) async => const Right(expectedDoctors));

      final useCase = GetAvailableDoctorsUseCase(repository);
      final result = await useCase(NoParams());

      result.fold((failure) => fail('Expected success'), (doctors) {
        expect(doctors, expectedDoctors);
        expect(doctors.first.name, 'Dr. Samir');
      });
    });
  });
}
