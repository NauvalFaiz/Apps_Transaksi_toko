class RiwayatTransaksiResponse {
  final bool status;
  final String message;
  final List<RiwayatTransaksi> data;

  RiwayatTransaksiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RiwayatTransaksiResponse.fromJson(Map<String, dynamic> json) {
    return RiwayatTransaksiResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => RiwayatTransaksi.fromJson(e))
          .toList(),
    );
  }
}

// ================= TRANSAKSI =================
class RiwayatTransaksi {
  final int idTransaksi;
  final String namaUser;
  final String tglTransaksi;
  final List<DetailBarang> detail;

  RiwayatTransaksi({
    required this.idTransaksi,
    required this.namaUser,
    required this.tglTransaksi,
    required this.detail,
  });

  factory RiwayatTransaksi.fromJson(Map<String, dynamic> json) {
    return RiwayatTransaksi(
      idTransaksi: json['id_transaksi'] ?? 0,
      namaUser: json['nama_user'] ?? '',
      tglTransaksi: json['tgl_transaksi'] ?? '',
      detail: (json['detail'] as List? ?? [])
          .map((e) => DetailBarang.fromJson(e))
          .toList(),
    );
  }

  // 🔥 total harga semua barang
  int get totalHarga =>
      detail.fold(0, (sum, item) => sum + item.subtotal);

  // 🔥 total item
  int get totalItem =>
      detail.fold(0, (sum, item) => sum + item.quantity);
}

// ================= DETAIL BARANG =================
class DetailBarang {
  final int idDetail;
  final int barangId;
  final String namaBarang;
  final int quantity;
  final int hargaBeli;

  DetailBarang({
    required this.idDetail,
    required this.barangId,
    required this.namaBarang,
    required this.quantity,
    required this.hargaBeli,
  });

  factory DetailBarang.fromJson(Map<String, dynamic> json) {
    return DetailBarang(
      idDetail: json['id_detail_transaksi'] ?? 0,
      barangId: json['barang_id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '',
      quantity: json['quantity'] ?? 0,
      hargaBeli: json['harga_beli'] ?? 0,
    );
  }

  int get subtotal => hargaBeli * quantity;
}