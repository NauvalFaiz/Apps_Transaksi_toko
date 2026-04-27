import 'package:flutter/material.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_user_login.dart';

class UserProvider extends ChangeNotifier {
  ModelsUserLogin? _currentUser;
  bool _isLoggedIn = false;

  // Getter
  ModelsUserLogin? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _currentUser?.nama_user;
  String? get userRole => _currentUser?.role;
  String? get userEmail => _currentUser?.email;
  int? get userId => _currentUser?.id;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> addUser({
    required String nama,
    required String email,
    required String password,
    required String role,
  }) async {
    _errorMessage = null;
    notifyListeners();
    // Placeholder for actual implementation
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> updateUser({
    required int id,
    required String name,
    required String email,
    required String role,
  }) async {
    _errorMessage = null;
    notifyListeners();
    // Placeholder for actual implementation
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Load user from SharedPreferences saat app dibuka
  Future<void> loadUserFromStorage() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();

    if (user.status == true && user.token != null) {
      _currentUser = user;
      _isLoggedIn = true;
    } else {
      _currentUser = null;
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  // Set user setelah login/register berhasil
  void setUser(ModelsUserLogin user) {
    _currentUser = user;
    _isLoggedIn = user.status == true;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();

    // Clear SharedPreferences
    ModelsUserLogin userLogin = ModelsUserLogin();
    await userLogin.getUserLogin();
    // Anda bisa menambahkan clear di UserLogin model jika diperlukan

    notifyListeners();
  }

  // Update user data
  void updateUserData({String? nama, String? role, String? email}) {
    if (_currentUser != null) {
      _currentUser = ModelsUserLogin(
        status: _currentUser!.status,
        token: _currentUser!.token,
        message: _currentUser!.message,
        id: _currentUser!.id,
        nama_user: nama ?? _currentUser!.nama_user,
        email: email ?? _currentUser!.email,
        role: role ?? _currentUser!.role,
      );
      notifyListeners();
    }
  }
}
