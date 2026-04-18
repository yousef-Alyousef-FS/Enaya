import 'mock_base_service.dart';

class MockUserService extends MockBaseService {
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    await delay();

    try {
      final data = await loadJson('auth_responses.json');
      final users = data['users'] as List?;

      if (users != null) {
        for (final user in users) {
          if (user['id'].toString() == userId) {
            return {
              'success': true,
              'user': {
                'id': user['id'],
                'email': user['email'],
                'userName': user['username'],
                'phone': user['phone'],
                'roleId': user['roleId'],
              },
            };
          }
        }
      }

      return {
        'success': false,
        'error': 'المستخدم غير موجود',
        'errorCode': 404,
      };
    } catch (e) {
      throw MockDataException('Get user profile mock failed: $e');
    }
  }
}
