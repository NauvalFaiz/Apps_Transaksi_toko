import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models_respont_data_list.dart';
import '../models/models_respont_data_map.dart';
import '../models/models_riwayatTransaksi.dart';
import '../models/models_user_login.dart';
import '../models/models_product.dart';
import '../utils/Api/api_constans_api_backend.dart' as url;

class ServiceUser {
  // ================= TOKEN =================
  Future<String?> _getToken() async {
    final user = await ModelsUserLogin().getUserLogin();
    return user.token;
  }

  Map<String, String> _authHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ================= REGISTER =================
  Future<ModelsRespontDataMap> registerUser(data) async {
    try {
      var uri = Uri.parse('${url.BaseUrl}/auth/register');
      var res = await http.post(uri, body: data);

      var body = json.decode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        return ModelsRespontDataMap(
          status: true,
          message: body['message'] ?? 'Sukses register',
          data: body['data'],
        );
      }

      return ModelsRespontDataMap(
        status: false,
        message: body['message'] ?? 'Registrasi gagal',
      );
    } catch (e) {
      return ModelsRespontDataMap(status: false, message: 'Error: $e');
    }
  }

  // ================= LOGIN =================
  Future<ModelsUserLogin?> loginUser(Map<String, dynamic> data) async {
    try {
      var uri = Uri.parse('${url.BaseUrl}/auth/login');
      var res = await http.post(uri, body: data);

      var body = json.decode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        ModelsUserLogin user = ModelsUserLogin(
          status: true,
          token: body['token'],
          message: body['message'],
          id: body['user']?['id'],
          email: body['user']?['email'],
          role: body['user']?['role'],
        );

        await user.prefs();
        return user;
      }
    } catch (e) {
      print("Login error: $e");
    }

    return null;
  }

  // ================= GET BARANG =================
  Future<ModelsRespontDataList> getBarang() async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${url.BaseUrl}/user/getbarang');

      final res = await http.get(uri, headers: _authHeaders(token));

      final body = json.decode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        List<ModelsProduct> data = (body['data'] as List)
            .map((e) => ModelsProduct.fromJson(e))
            .toList();

        return ModelsRespontDataList(
          status: true,
          message: body['message'],
          data: data,
        );
      }

      return ModelsRespontDataList(
        status: false,
        message: body['message'] ?? 'Gagal ambil barang',
      );
    } catch (e) {
      return ModelsRespontDataList(status: false, message: 'Error: $e');
    }
  }

  // ================= TRANSAKSI =================
  Future<ModelsRespontDataMap> buatTransaksi(
      List<Map<String, dynamic>> pesanList,) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${url.BaseUrl}/user/transaksi');

      final res = await http.post(
        uri,
        headers: _authHeaders(token),
        body: json.encode({'pesan': pesanList}),
      );

      final body = json.decode(res.body);

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          body['status'] == true) {
        return ModelsRespontDataMap(
          status: true,
          message: body['message'] ?? 'Transaksi berhasil',
          data: body['data'],
        );
      }

      return ModelsRespontDataMap(
        status: false,
        message: body['message'] ?? 'Transaksi gagal',
      );
    } catch (e) {
      return ModelsRespontDataMap(status: false, message: 'Error: $e');
    }
  }

// Di dalam ServiceUser class
  Future<RiwayatTransaksiResponse> getRiwayatTransaksi() async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${url.BaseUrl}/user/history_trans');

      final res = await http.get(uri, headers: _authHeaders(token));
      final body = json.decode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        return RiwayatTransaksiResponse.fromJson(body);
      } else {
        return RiwayatTransaksiResponse(
          status: false,
          message: body['message'] ?? 'Gagal memuat data',
          data: [],
        );
      }
    } catch (e) {
      print("Error getRiwayatTransaksi: $e");
      return RiwayatTransaksiResponse(
        status: false,
        message: 'Error: $e',
        data: [],
      );
    }
  }

// Method untuk mendapatkan detail transaksi
  Future<RiwayatTransaksi?> getDetailTransaksi(int idTransaksi) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('${url.BaseUrl}/user/history_trans/$idTransaksi');

      final res = await http.get(uri, headers: _authHeaders(token));
      final body = json.decode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        return RiwayatTransaksi.fromJson(body['data']);
      }

      return null;
    } catch (e) {
      print("Detail error: $e");
      return null;
    }
  }
}