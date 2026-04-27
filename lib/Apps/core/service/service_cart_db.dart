import 'package:flutter_mobile_modul/Apps/core/service/service_cart_detail.dart';

class ServiceCartDb {
  final int? id_transaksi;
  final String? nama_user;
  final String? tgl_transaksi;
  final List<ServiceCartDetail>? detail;
  ServiceCartDb({
    this.id_transaksi,
    this.nama_user,
    this.tgl_transaksi,
    this.detail,
  });
  factory ServiceCartDb.fromMap(Map<String, dynamic> json) {
    return ServiceCartDb(
      id_transaksi: json['id_transaksi'],
      nama_user: json['nama_user'],
      tgl_transaksi: json['tgl_transaksi'],
      detail: json['detail'] != null
          ? List<ServiceCartDetail>.from(
              json['detail'].map((x) => ServiceCartDetail.fromMap(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_transaksi': id_transaksi,
      'nama_user': nama_user,
      'tgl_transaksi': tgl_transaksi,
      'detail': detail != null
          ? List<dynamic>.from(detail!.map((x) => x.toMap()))
          : null,
    };
  }
}
