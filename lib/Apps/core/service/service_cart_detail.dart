class ServiceCartDetail {
  late final int? id_detail_transaksi;
  late final int? barang_id;
  late final String? nama_barang;
  late final int? quantity;
  late final int? harga_beli;

  ServiceCartDetail({
    this.id_detail_transaksi,
    this.barang_id,
    this.nama_barang,
    this.quantity,
    this.harga_beli,
  });
  factory ServiceCartDetail.fromMap(Map<String, dynamic> json) {
    return ServiceCartDetail(
      id_detail_transaksi: json['id_detail_transaksi'],
      barang_id: json['barang_id'],
      nama_barang: json['nama_barang'],
      quantity: json['quantity'],
      harga_beli: json['harga_beli'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_detail_transaksi': id_detail_transaksi,
      'barang_id': barang_id,
      'nama_barang': nama_barang,
      'quantity': quantity,
      'harga_beli': harga_beli,
    };
  }
}
