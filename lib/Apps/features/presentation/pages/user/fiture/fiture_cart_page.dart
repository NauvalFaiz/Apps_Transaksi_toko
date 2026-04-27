import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/provider/provider_cart_item.dart';
import '../../../../../core/service/service_user.dart';
import '../../../../../core/widget/alerts/alert_message.dart';
import '../../../../../core/utils/Api/api_constans_api_backend.dart' as url;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _serviceUser = ServiceUser();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              tooltip: 'Kosongkan',
              onPressed: _isSubmitting ? null : () => _confirmClear(cart),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: cart.items.isEmpty ? _emptyState(context) : _cartList(cart),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : _bottomBar(
              totalItems: cart.totalItems,
              totalHarga: cart.totalHarga,
              onPesan: _isSubmitting ? null : () => _confirmPesan(cart),
              onBatal: _isSubmitting ? null : () => _confirmClear(cart),
              isSubmitting: _isSubmitting,
            ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: Colors.grey.withAlpha(153),
            ),
            const SizedBox(height: 12),
            const Text(
              'Keranjang masih kosong',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Tambahkan produk dulu dari halaman product.',
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartList(CartProvider cart) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cart.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return _cartItemTile(
          item: item,
          onIncrease: _isSubmitting || item.id == null
              ? null
              : () => cart.increaseQty(item.id!),
          onDecrease: _isSubmitting || item.id == null
              ? null
              : () => cart.decreaseQty(item.id!),
          onRemove: _isSubmitting || item.id == null
              ? null
              : () => cart.removeItem(item.id!),
        );
      },
    );
  }

  Widget _cartItemTile({
    required ProviderCartItem item,
    required VoidCallback? onIncrease,
    required VoidCallback? onDecrease,
    required VoidCallback? onRemove,
  }) {
    final harga = item.harga ?? 0;
    final subtotal = harga * item.qty;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productImage(item.image),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp $harga',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrease,
                        icon: const Icon(Icons.remove_circle_outline),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Kurangi',
                      ),
                      Text(
                        '${item.qty}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: onIncrease,
                        icon: const Icon(Icons.add_circle_outline),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Tambah',
                      ),
                      const Spacer(),
                      Text(
                        'Rp $subtotal',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.close),
                        tooltip: 'Hapus item',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(String? imagePath) {
    final path = (imagePath ?? '').trim();
    final hasImage = path.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 44,
        height: 44,
        color: Colors.blue.withAlpha(20),
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: Uri.encodeFull('${url.baseImageUrl}/$path'),
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.blue,
                ),
              )
            : const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.blue,
              ),
      ),
    );
  }

  Widget _bottomBar({
    required int totalItems,
    required int totalHarga,
    required VoidCallback? onPesan,
    required VoidCallback? onBatal,
    required bool isSubmitting,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$totalItems item',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  'Total: Rp $totalHarga',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBatal,
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPesan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Pesan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmPesan(CartProvider cart) async {
    if (cart.items.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Pemesanan'),
        content: Text(
          'Pesan ${cart.totalItems} item dengan total Rp ${cart.totalHarga}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Pesan'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() => _isSubmitting = true);
    final result = await _serviceUser.buatTransaksi(cart.toPesanList());
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.status == true) {
      cart.clear();
      AlertMassage().showAlert(context, result.message, true);
      Navigator.pop(context);
    } else {
      AlertMassage().showAlert(context, result.message, false);
    }
  }

  Future<void> _confirmClear(CartProvider cart) async {
    if (cart.items.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pemesanan'),
        content: const Text('Kosongkan semua item di keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, kosongkan'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    cart.clear();
    if (!mounted) return;
    AlertMassage().showAlert(context, 'Keranjang dikosongkan', true);
  }
}

