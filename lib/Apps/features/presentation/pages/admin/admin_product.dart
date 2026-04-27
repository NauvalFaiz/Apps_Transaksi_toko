import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/models/models_product.dart';
import '../../../../core/service/service_product.dart';
import '../../../../core/widget/alerts/alert_message.dart';

import '../user/fiture/fiture_ProdukDetailScreen.dart';
import '../user/fiture/fiture_ProdukFormScreen.dart';
import '../../../../core/utils/Api/api_constans_api_backend.dart' as url;

class AdminProdukPage extends StatefulWidget {
  const AdminProdukPage({super.key});

  @override
  State<AdminProdukPage> createState() => _AdminProdukPageState();
}

class _AdminProdukPageState extends State<AdminProdukPage> {
  final ServiceProduct _productService = ServiceProduct();
  List<ModelsProduct> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdminProduk();
  }

  Future<void> _loadAdminProduk() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _productService.getToko();

      if (mounted) {
        if (response.status == true) {
          setState(() {
            _products = response.data as List<ModelsProduct>;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = response.message ?? 'Gagal memuat produk';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat produk: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<ModelsProduct> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;

    return _products.where((product) {
      return (product.nama_barang?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false) ||
          (product.kategori?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);
    }).toList();
  }

  Future<void> _deleteProduct(int id, String nama) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin menghapus produk "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final result = await _productService.deleteToko(context, id);

      if (!mounted) return;

      if (result.status == true) {
        AlertMassage().showAlert(context, result.message, true);

        // 🔥 FIX: kasih delay + reload
        await Future.delayed(const Duration(milliseconds: 300));
        await _loadAdminProduk();
      } else {
        AlertMassage().showAlert(context, result.message, false);
      }
    } catch (e) {
      if (mounted) {
        AlertMassage().showAlert(context, 'Gagal menghapus: $e', false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAdminProduk,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(child: _buildProductList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProdukFormScreen()),
          ).then((value) {
            if (value == true) _loadAdminProduk();
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            Text(_errorMessage),
            ElevatedButton(
              onPressed: _loadAdminProduk,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return const Center(child: Text('Tidak ada produk ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: _loadAdminProduk,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(ModelsProduct product) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: Uri.encodeFull("${url.baseImageUrl}/${product.image}"),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => const Icon(Icons.image),
          ),
        ),
        title: Text(
          product.nama_barang ?? 'Tanpa Nama',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Rp ${product.harga} • Stok: ${product.stok}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProdukFormScreen(product: product),
                  ),
                ).then((value) {
                  if (value == true) _loadAdminProduk();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  _deleteProduct(product.id ?? 0, product.nama_barang ?? ''),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdukDetailScreen(produk: product),
            ),
          ).then((value) {
            if (value == true) _loadAdminProduk();
          });
        },
      ),
    );
  }
}
