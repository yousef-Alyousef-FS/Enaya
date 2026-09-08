class UserApiResponse {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int roleId;

  const UserApiResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
  });

  factory UserApiResponse.fromApi(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final user = data['user'] ?? {};

    return UserApiResponse(
      id: user['id']?.toString() ?? '',
      name: user['username'] ?? user['name'] ?? '',
      email: user['email'] ?? '',
      phone: user['phone'] ?? '',
      roleId: user['roleId'] ?? 0,
    );
  }

  Map<String, dynamic> toUserJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
