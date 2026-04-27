class CartItem {
  final int? id;
  final String? nama;
  final int? harga;
  final String? image;
  final String? kategori;
  final int? stokMax;
  final int qty;

  const CartItem({
    this.id,
    this.nama,
    this.harga,
    this.image,
    this.kategori,
    this.stokMax,
    this.qty = 1,
  });

  CartItem copyWith({
    int? id,
    String? nama,
    int? harga,
    String? image,
    String? kategori,
    int? stokMax,
    int? qty,
  }) {
    return CartItem(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      image: image ?? this.image,
      kategori: kategori ?? this.kategori,
      stokMax: stokMax ?? this.stokMax,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toPesan() => {'barang_id': id, 'qty': qty};

  int get subtotal => (harga ?? 0) * qty;
}