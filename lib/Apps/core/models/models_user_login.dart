import 'package:shared_preferences/shared_preferences.dart';

class ModelsUserLogin {
  bool? status = false;
  String? token;
  String? message;
  int? id;
  String? nama_user;
  String? email;
  String? role;

  ModelsUserLogin({
    this.status,
    this.token,
    this.message,
    this.id,
    this.nama_user,
    this.email,
    this.role,
  });

  Future prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (status != null) prefs.setBool("status", status!);
    if (token != null) prefs.setString("token", token!);
    if (message != null) prefs.setString("message", message!);
    if (id != null) prefs.setInt("id", id!);
    if (nama_user != null) prefs.setString("name", nama_user!);
    if (email != null) prefs.setString("email", email!);
    if (role != null) prefs.setString("role", role!);
  }

  Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ModelsUserLogin modelsUserLogin = ModelsUserLogin(
      status: prefs.getBool("status"),
      token: prefs.getString("token"),
      message: prefs.getString("message"),
      id: prefs.getInt("id"),
      nama_user: prefs.getString("name"),
      email: prefs.getString("email"),
      role: prefs.getString("role"),
    );
    return modelsUserLogin;
  }

  Future clearUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("status");
    await prefs.remove("token");
    await prefs.remove("message");
    await prefs.remove("id");
    await prefs.remove("name");
    await prefs.remove("email");
    await prefs.remove("role");
  }

  ModelsUserLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    id = json['data']?['id'];
    nama_user = json['data']?['name'];
    email = json['data']?['email'];
    role = json['data']?['role'];
  }
}

