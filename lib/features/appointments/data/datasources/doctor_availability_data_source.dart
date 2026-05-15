import 'package:flutter/material.dart';
import '../models/doctor_availability_model.dart';

// ============================================================================
// ?? Abstract Interface
// ============================================================================
abstract class DoctorAvailabilityDataSource {
  /// Fetch doctor availability including working hours, breaks, and off days
  Future<DoctorAvailability> getDoctorAvailability(String doctorId);

  /// Save or update doctor availability
  Future<void> saveDoctorAvailability(DoctorAvailability availability);
}

// ============================================================================
// ?? Mock Implementation
// ============================================================================
class DoctorAvailabilityMockDataSource implements DoctorAvailabilityDataSource {
  @override
  Future<DoctorAvailability> getDoctorAvailability(String doctorId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return realistic mock data
    return DoctorAvailability(
      doctorId: doctorId,
      workingDays: [
        _workingDay(DateTime.monday, 9, 17, hasBreak: true),
        _workingDay(DateTime.tuesday, 9, 17),
        _workingDay(DateTime.wednesday, 9, 17, hasBreak: true),
        _workingDay(DateTime.thursday, 9, 17),
        _workingDay(DateTime.friday, 9, 13), // Short day
        _workingDay(DateTime.saturday, 10, 14),
      ],
      appointmentDurationMinutes: 30,
    );
  }

  @override
  Future<void> saveDoctorAvailability(DoctorAvailability availability) async {
    // Mock save - simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Helper to create working days for mock data
  WorkingDay _workingDay(
    int day,
    int startH,
    int endH, {
    bool hasBreak = false,
  }) {
    final List<BreakTime> breaks = hasBreak
        ? [
            const BreakTime(
              startTime: TimeOfDay(hour: 13, minute: 0),
              endTime: TimeOfDay(hour: 14, minute: 0),
            ),
          ]
        : [];

    return WorkingDay(
      dayOfWeek: day,
      startTime: TimeOfDay(hour: startH, minute: 0),
      endTime: TimeOfDay(hour: endH, minute: 0),
      breaks: breaks,
    );
  }
}
