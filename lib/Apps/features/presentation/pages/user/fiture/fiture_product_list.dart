import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_modul/Apps/core/service/service_product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/models_product.dart';
import '../../../../../core/provider/provider_cart_item.dart';
import '../../../../../core/provider/provider_user.dart';

import 'fiture_ProdukDetailScreen.dart';
import 'fiture_ProdukFormScreen.dart';
import 'fiture_cart_page.dart';
import '../../../../../core/utils/Api/api_constans_api_backend.dart' as url;

class ProdukListScreen extends StatefulWidget {
  const ProdukListScreen({super.key});

  @override
  State<ProdukListScreen> createState() => _ProdukListScreenState();
}

class _ProdukListScreenState extends State<ProdukListScreen> {
  final ServiceProduct _produkService = ServiceProduct();
  List<ModelsProduct> _produkList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  Future<void> _fetchProduk() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _produkService.getToko();

      if (!mounted) return;

      if (response.status == true) {
        setState(() {
          _produkList = (response.data as List).cast<ModelsProduct>().toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool isAdmin = userProvider.userRole == 'admin';
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Daftar Product',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
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
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProdukFormScreen()),
                ).then((_) => _fetchProduk());
              },
            ),
        ],
      ),
      body: _buildBody(isAdmin),
    );
  }

  Widget _buildBody(bool isAdmin) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_produkList.isEmpty) {
      return const Center(child: Text("Belum ada produk"));
    }

    return RefreshIndicator(
      onRefresh: _fetchProduk,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(15),
        itemCount: _produkList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return _buildProdukCard(_produkList[index], isAdmin);
        },
      ),
    );
  }

  Widget _buildProdukCard(ModelsProduct produk, bool isAdmin) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdukDetailScreen(produk: produk),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Gambar
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: Uri.encodeFull(
                      "${url.baseImageUrl}/${produk.image}",
                    ),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image),
                  ),
                ),
                Positioned(
                  top: 33,
                  right: -10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Color(0xff1B275C),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: -10,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 20,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff4960CB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama_barang ?? 'No Name',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Rp ${produk.harga}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Stok: ${produk.stok}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      if (!isAdmin)
                        IconButton(
                          icon: const Icon(Icons.shopping_cart, size: 18),
                          onPressed: () => _addToCart(produk),
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

  void _addToCart(ModelsProduct produk) {
    final cart = context.read<CartProvider>();
    final id = produk.id;
    final stok = produk.stok ?? 0;

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

    final before = cart.qtyOf(id);
    cart.addItem(
      ProviderCartItem(
        id: id,
        nama: produk.nama_barang,
        harga: produk.harga,
        image: produk.image,
        kategori: produk.kategori,
        stokMax: stok,
        qty: 1,
      ),
    );

    final after = cart.qtyOf(id);
    final isAdded = after > before;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded
              ? '${produk.nama_barang} ditambahkan ke keranjang'
              : 'Qty sudah mencapai stok maksimal',
        ),
        backgroundColor: isAdded ? Colors.green : Colors.orange,
      ),
    );
  }
}
