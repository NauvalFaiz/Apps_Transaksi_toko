import 'dart:ui';

import 'package:flutter_mobile_modul/Apps/core/models/models_user_login.dart';

class UtilsUser {
  static Future<ModelsUserLogin?> getCurrentUser() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    if (user.status == true && user.name != null) {
      return user;
    }
    return null;
  }

  static Future<bool> isUserLoggedIn() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.status == true && user.token != null;
  }

  static Future<bool> isUserAdmin() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.role?.toLowerCase() == 'admin';
  }

  static Future<bool> isRegularUser() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.role?.toLowerCase() == 'user';
  }

  static Future<String?> getUserName() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.name;
  }

  static Future<String?> getUserRole() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.role;
  }

  static Future<String?> getUserEmail() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.email;
  }

  static Future<int?> getUserId() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.id;
  }

  static Future<String?> getUserToken() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();
    return user.token;
  }

  static Future<void> logoutUser() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.clearUserLogin();
    return user.token;
  }

  static Future<String> getGreetingMessage() async {
    final name = await getUserName();
    return 'Halo, ${name ?? 'User'}!';
  }

  static String getRoleDisplayText(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'user':
        return 'Pengguna Biasa';
      default:
        return 'Unknown Role';
    }
  }

  static Color getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return Color(0xFFFF6B6B); // Red
      case 'user':
        return Color(0xFF51CF66); // Green
      default:
        return Color(0xFF868E96); // Gray
    }
  }
}
