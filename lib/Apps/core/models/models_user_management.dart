class UserManagementModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? createdAt;
  final String? updatedAt;

  UserManagementModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserManagementModel.fromJson(Map<String, dynamic> json) {
    return UserManagementModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  bool get isAdmin => role == 'admin';
}