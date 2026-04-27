import 'package:flutter/material.dart';
import '../models/models_user_management.dart';
import '../service/service_user_management.dart';

class UserManagementProvider extends ChangeNotifier {

  final UserManagementService _service = UserManagementService();

  List<UserManagementModel> _users = [];
  List<UserManagementModel> get users => _users;

  bool isLoading = false;
  String? error;

  Future<void> fetchUsers() async {

    try {
      isLoading = true;
      notifyListeners();

      _users = await _service.getUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<UserManagementModel> get adminUsers =>
      _users.where((u) => u.role == 'admin').toList();

  List<UserManagementModel> get normalUsers =>
      _users.where((u) => u.role == 'user').toList();

}
