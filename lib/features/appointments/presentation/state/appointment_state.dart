import 'package:easy_localization/easy_localization.dart';
import '../../../../core/view_models/base_view_model.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_status.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/usecases/get_appointments_by_date_usecase.dart';
import '../../domain/usecases/get_today_appointments_usecase.dart';

class AppointmentState extends BaseViewModel {
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final GetAppointmentsByDateUseCase _getAppointmentsByDateUseCase;
  final GetTodayAppointmentsUseCase _getTodayAppointmentsUseCase;

  final int userRoleId;

  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<AppointmentEntity> _appointments = [];
  int _currentPage = 1;
  int _pageSize = 20;
  bool _hasMore = true;
  bool _isPageLoading = false;

  AppointmentState({
    required CreateAppointmentUseCase createAppointmentUseCase,
    required GetAppointmentsByDateUseCase getAppointmentsByDateUseCase,
    required GetTodayAppointmentsUseCase getTodayAppointmentsUseCase,
    required this.userRoleId,
  }) : _createAppointmentUseCase = createAppointmentUseCase,
       _getAppointmentsByDateUseCase = getAppointmentsByDateUseCase,
       _getTodayAppointmentsUseCase = getTodayAppointmentsUseCase;

  DateTime get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  List<AppointmentEntity> get appointments => _appointments;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;
  bool get isPageLoading => _isPageLoading;
  bool get canSchedule => userRoleId == 3;

  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null;
    notifyListeners();
  }

  void updateSelectedTimeSlot(String slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  String _resolveFailureMessage(String message) {
    final normalized = message.toLowerCase();

    if (normalized.contains('timeout')) {
      return 'error_connection_timeout'.tr();
    }
    if (normalized.contains('socketexception') ||
        normalized.contains('connection') ||
        normalized.contains('internet')) {
      return 'no_internet_connection'.tr();
    }
    if (normalized.contains('unauthorized') || normalized.contains('401')) {
      return 'error_unauthorized'.tr();
    }
    if (normalized.contains('forbidden') || normalized.contains('403')) {
      return 'error_forbidden'.tr();
    }
    if (normalized.contains('not found') || normalized.contains('404')) {
      return 'error_not_found'.tr();
    }

    return 'error_occurred'.tr();
  }

  Future<void> fetchTodayAppointments({int page = 1, int limit = 20}) async {
    if (_isPageLoading) return;
    _isPageLoading = true;
    setState(ViewState.loading);
    _selectedDate = DateTime.now();
    _currentPage = page;
    _pageSize = limit;

    try {
      final result = await _getTodayAppointmentsUseCase(
        GetTodayAppointmentsParams(page: page, limit: limit),
      );

      result.fold(
        (failure) => setError(_resolveFailureMessage(failure.message)),
        (appointments) {
          _appointments = appointments;
          _hasMore = appointments.length == limit;
          setState(ViewState.success);
        },
      );
    } finally {
      _isPageLoading = false;
    }
  }

  Future<void> loadNextTodayAppointmentsPage() async {
    if (!_hasMore || _isPageLoading) return;
    await fetchTodayAppointments(page: _currentPage + 1, limit: _pageSize);
  }

  Future<void> loadPreviousTodayAppointmentsPage() async {
    if (_currentPage <= 1 || _isPageLoading) return;
    await fetchTodayAppointments(page: _currentPage - 1, limit: _pageSize);
  }

  Future<void> fetchAppointmentsByDate(
    DateTime date, {
    AppointmentStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    if (_isPageLoading) return;
    _isPageLoading = true;
    setState(ViewState.loading);
    _selectedDate = date;
    _currentPage = page;
    _pageSize = limit;

    try {
      final result = await _getAppointmentsByDateUseCase(
        GetAppointmentsByDateParams(
          date: date,
          status: status,
          page: page,
          limit: limit,
        ),
      );

      result.fold(
        (failure) => setError(_resolveFailureMessage(failure.message)),
        (appointments) {
          _appointments = appointments;
          _hasMore = appointments.length == limit;
          setState(ViewState.success);
        },
      );
    } finally {
      _isPageLoading = false;
    }
  }

  Future<void> loadNextAppointmentsByDatePage({
    AppointmentStatus? status,
  }) async {
    if (!_hasMore || _isPageLoading) return;
    await fetchAppointmentsByDate(
      _selectedDate,
      status: status,
      page: _currentPage + 1,
      limit: _pageSize,
    );
  }

  Future<void> loadPreviousAppointmentsByDatePage({
    AppointmentStatus? status,
  }) async {
    if (_currentPage <= 1 || _isPageLoading) return;
    await fetchAppointmentsByDate(
      _selectedDate,
      status: status,
      page: _currentPage - 1,
      limit: _pageSize,
    );
  }

  Future<void> createAppointment({
    required String patientId,
    required String patientName,
    required String doctorId,
    required String doctorName,
    String? reason,
  }) async {
    if (!canSchedule) {
      setError('unauthorized_receptionist_only'.tr());
      return;
    }

    if (_selectedTimeSlot == null) {
      setError('select_time_slot'.tr());
      return;
    }

    setState(ViewState.loading);

    final newAppointment = AppointmentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patientId,
      patientName: patientName,
      doctorId: doctorId,
      doctorName: doctorName,
      dateTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(_selectedTimeSlot!.split(':')[0]),
        int.parse(_selectedTimeSlot!.split(':')[1]),
      ),
      status: AppointmentStatus.scheduled,
      reason: reason,
    );

    final result = await _createAppointmentUseCase(
      CreateAppointmentParams(newAppointment),
    );

    result.fold(
      (failure) => setError(_resolveFailureMessage(failure.message)),
      (appointment) {
        _appointments = [appointment, ..._appointments];
        setState(ViewState.success);
      },
    );
  }
}
