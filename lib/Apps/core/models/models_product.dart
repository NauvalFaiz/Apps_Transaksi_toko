
class ModelsProduct {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;
  String? kategori;
  double? rating;
  int? terjual;

  ModelsProduct({
    this.id,
    this.nama_barang,
    this.deskripsi,
    this.stok,
    this.harga,
    this.image,
    this.kategori,
    this.rating,
    this.terjual,
  });

  ModelsProduct.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num?)?.toInt();
    nama_barang = json['nama_barang'];
    deskripsi = json['deskripsi'];

    stok = (json['stok'] as num?)?.toInt();
    harga = (json['harga'] as num?)?.toInt();

    image = json['image'];
    kategori = json['kategori'];

    rating = (json['rating'] as num?)?.toDouble();
    terjual = (json['terjual'] as num?)?.toInt();

  }

   operator [](String other) {}
}