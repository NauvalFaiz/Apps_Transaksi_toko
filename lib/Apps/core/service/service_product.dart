import 'dart:convert';

import 'package:flutter_mobile_modul/Apps/core/models/models_product.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_respont_data_list.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_user_login.dart';
import 'package:http/http.dart' as http;

import '../utils/Api/api_constans_api_backend.dart' as url;

class ServiceProduct {
  Future getToko() async {
    ModelsUserLogin modelsUserLogin = ModelsUserLogin();
    var user = await modelsUserLogin.getUserLogin();

    if (user.status == false) {
      return ModelsRespontDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }
    final isAdmin = user.role == 'admin';

    final uri = Uri.parse(
      isAdmin
          ? "${url.BaseUrl}/admin/getbarang"
          : "${url.BaseUrl}/user/getbarang",
    );

    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data["status"] == true) {
        List<ModelsProduct> toko = (data["data"] as List)
            .map((r) => ModelsProduct.fromJson(r))
            .toList();

        return ModelsRespontDataList(
          status: true,
          message: 'success load data',
          data: toko,
        );
      } else {
        return ModelsRespontDataList(
          status: false,
          message: data["message"] ?? 'Failed load data',
        );
      }
    } else {
      return ModelsRespontDataList(
        status: false,
        message: "Error ${response.statusCode}",
      );
    }
  }

  //menamah barang
  //membuat fungsi untuk insert dan update
  Future insertToko(request, image, id) async {
    var user = await ModelsUserLogin().getUserLogin();
    if (user.status == false) {
      return ModelsRespontDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }

    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

    // Tentukan endpoint insert atau update
    final endpoint = id == null
        ? Uri.parse("${url.BaseUrl}/admin/insertbarang")
        : Uri.parse("${url.BaseUrl}/admin/updatebarang/$id");

    var multipartRequest = http.MultipartRequest("POST", endpoint);
    multipartRequest.headers.addAll(headers);

    // Isi fields
    multipartRequest.fields['nama_barang'] = request['nama_barang'].toString();
    multipartRequest.fields['deskripsi'] = request['deskripsi'].toString();
    multipartRequest.fields['stok'] = request['stok'].toString();
    multipartRequest.fields['harga'] = request['harga'].toString();
    multipartRequest.fields['kategori'] = request['kategori'].toString();

    // ── FIX: pakai fromPath agar tidak hang ──
    if (image != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );
    }

    try {
      var streamedResponse = await multipartRequest.send();
      var result = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        var data = json.decode(result.body);
        if (data["status"] == true) {
          return ModelsRespontDataList(
            status: true,
            message: data["message"] ?? "success",
          );
        } else {
          return ModelsRespontDataList(
            status: false,
            message: data["message"] ?? "Failed insert data",
          );
        }
      } else {
        return ModelsRespontDataList(
          status: false,
          message:
              "gagal insert toko dengan code error ${streamedResponse.statusCode}",
        );
      }
    } catch (e) {
      return ModelsRespontDataList(
        status: false,
        message: "Terjadi kesalahan: $e",
      );
    }
  }

  //hapus barang
  //membuat fungsi untuk hapus barang
  Future deleteToko(context, id) async {
    var user = await ModelsUserLogin().getUserLogin();
    if (user.status == false) {
      return ModelsRespontDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }
    //hapus barang berdasarkan id
    var uri = Uri.parse("${url.BaseUrl}/admin/hapusbarang/$id");
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Accept": "application/json",
    };
    var deleteToko = await http.delete(uri, headers: headers);

    if (deleteToko.statusCode == 200) {
      var result = json.decode(deleteToko.body);
      if (result["status"] == true) {
        return ModelsRespontDataList(
          status: true,
          message: result["message"] ?? 'Sukses hapus data',
        );
      } else {
        return ModelsRespontDataList(
          status: false,
          message: result["message"] ?? 'Failed hapus data',
        );
      }
    } else {
      return ModelsRespontDataList(
        status: false,
        message: "gagal hapus toko dengan code error ${deleteToko.statusCode}",
      );
    }
  }
}
