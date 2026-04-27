import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_user_management.dart';

class UserManagementService {
  final String baseUrl =
      "https://learn.smktelkom-mlg.sch.id/toko/api/admin/getuser";

  Future<List<UserManagementModel>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List users = data['user'];

      return users.map((e) => UserManagementModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data user");
    }
  }
}