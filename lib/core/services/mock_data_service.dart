import 'mock/mock_auth_service.dart';
import 'mock/mock_user_service.dart';

class MockDataService {
  final auth = MockAuthService();
  final user = MockUserService();
}
