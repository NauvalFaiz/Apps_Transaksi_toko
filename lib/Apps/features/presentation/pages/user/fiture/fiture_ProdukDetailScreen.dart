import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_product.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/provider_cart_item.dart';
import '../../../../../core/provider/provider_user.dart';
import '../../../../../core/service/service_product.dart';
import '../../../../../core/service/service_user.dart';
import '../../../../../core/widget/alerts/alert_message.dart';
import '../../../../../core/utils/Api/api_constans_api_backend.dart' as url;

import 'fiture_ProdukFormScreen.dart';
import 'fiture_cart_page.dart';

class ProdukDetailScreen extends StatefulWidget {
  final ModelsProduct produk;

  const ProdukDetailScreen({super.key, required this.produk});

  @override
  State<ProdukDetailScreen> createState() => _ProdukDetailScreenState();
}

class _ProdukDetailScreenState extends State<ProdukDetailScreen> {
  final ServiceProduct _produkService = ServiceProduct();
  final ServiceUser _userService = ServiceUser();
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool isAdmin = userProvider.userRole == 'admin';
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          if (!isAdmin)
            IconButton(
              tooltip: 'Keranjang',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  if (cart.totalItems > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProdukFormScreen(product: widget.produk),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildImageSection(), _buildInfoSection(isAdmin)],
        ),
      ),
      bottomNavigationBar: !isAdmin && widget.produk.stok! > 0
          ? _buildBottomAction(context)
          : null,
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 300,
      color: Colors.grey[100],
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: Uri.encodeFull(
                "${url.baseImageUrl}/${widget.produk.image}",
              ),
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.image),
            ),
          ),
          Positioned(top: 16, right: 16, child: _stockBadge()),
        ],
      ),
    );
  }

  Widget _stockBadge() {
    final bool isOutOfStock = widget.produk.stok! <= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutOfStock ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOutOfStock ? "HABIS" : "TERSEDIA",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoSection(bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.produk.nama_barang ?? 'Tanpa Nama',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp ${widget.produk.harga}",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildDetailGrid(),
          if (!isAdmin && widget.produk.stok! > 0) _buildQuantitySelector(),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    final maxQuantity = widget.produk.stok;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'Stok tersedia: $maxQuantity',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _quantity > 1
                      ? () {
                          setState(() {
                            _quantity--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _quantity < maxQuantity!
                      ? () {
                          setState(() {
                            _quantity++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${widget.produk.harga! * _quantity}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.produk.deskripsi ?? '-',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      children: [
        _detailItem(
          icon: Icons.inventory,
          label: 'ID Produk',
          value: '#${widget.produk.id}',
        ),
        _detailItem(
          icon: Icons.warehouse,
          label: 'Stok',
          value: widget.produk.stok.toString(),
        ),
        _detailItem(
          icon: Icons.category,
          label: 'Kategori',
          value: widget.produk.kategori ?? '-',
        ),
      ],
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _addToCart(context),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Ke Keranjang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _buyNow(context),
              icon: const Icon(Icons.bolt),
              label: const Text('Beli Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final cart = context.read<CartProvider>();
    final id = widget.produk.id;
    final stok = widget.produk.stok ?? 0;

    if (id == null) return;
    if (stok <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok habis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final existing = cart.qtyOf(id);
    final maxAdd = (stok - existing).clamp(0, stok);
    if (maxAdd <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Qty sudah mencapai stok maksimal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final addCount = _quantity > maxAdd ? maxAdd : _quantity;
    for (var i = 0; i < addCount; i++) {
      cart.addItem(
        ProviderCartItem(
          id: id,
          nama: widget.produk.nama_barang,
          harga: widget.produk.harga,
          image: widget.produk.image,
          kategori: widget.produk.kategori,
          stokMax: stok,
          qty: 1,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.produk.nama_barang} (x$addCount) ditambahkan ke keranjang',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyNow(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pembelian'),
        content: Text(
          'Yakin membeli ${widget.produk.nama_barang} (x$_quantity)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final List<Map<String, dynamic>> pesanList = [
                {"barang_id": widget.produk.id, "qty": _quantity},
              ];

              final result = await _userService.buatTransaksi(pesanList);

              if (!mounted) return;

              if (result.status == true) {
                AlertMassage().showAlert(context, result.message, true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) Navigator.pop(context);
                });
              } else {
                AlertMassage().showAlert(context, result.message, false);
              }
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin hapus ${widget.produk.nama_barang}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final result = await _produkService.deleteToko(
                context,
                widget.produk.id,
              );
              if (!mounted) return;
              if (result.status == true) {
                AlertMassage().showAlert(context, result.message, true);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) Navigator.pop(context, true);
                });
              } else {
                AlertMassage().showAlert(context, result.message, false);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
