import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../../core/models/models_product.dart';
import '../../../../../core/provider/provider_user.dart';
import '../../../../../core/service/service_product.dart';
import '../../../../../core/widget/alerts/alert_message.dart';
import '../../../../../core/widget/widget_image_picker.dart';
import '../../../../../core/utils/Api/api_constans_api_backend.dart' as url;

class ProdukFormScreen extends StatefulWidget {
  final ModelsProduct? product;

  const ProdukFormScreen({super.key, this.product});

  @override
  State<ProdukFormScreen> createState() => _ProdukFormScreenState();
}

class _ProdukFormScreenState extends State<ProdukFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ServiceProduct _productService = ServiceProduct();

  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;
  late TextEditingController _deskripsiController;
  late TextEditingController _kategoriController;

  File? _imageFile;
  bool _isLoading = false;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.product?.nama_barang ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.product?.harga.toString() ?? '',
    );
    _stokController = TextEditingController(
      text: widget.product?.stok.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.product?.deskripsi ?? '',
    );
    _kategoriController = TextEditingController(
      text: widget.product?.kategori ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: Stack(
        children: [
          _buildForm(context),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ImagePickerWidget(
              onImageSelected: (File? image) {
                setState(() {
                  _imageFile = image;
                });
              },
              initialImageUrl: widget.product?.image != null
                  ? "${url.baseImageUrl}/images/${widget.product!.image}"
                  : null,
              label: 'Gambar Produk',
            ),
            const SizedBox(height: 24),
            _input(
              controller: _namaController,
              label: 'Nama Produk',
              icon: Icons.inventory,
              validator: (v) => v!.isEmpty ? 'Nama produk wajib diisi' : null,
            ),
            _input(
              controller: _hargaController,
              label: 'Harga',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Harga wajib diisi' : null,
            ),
            _input(
              controller: _stokController,
              label: 'Stok',
              icon: Icons.warehouse,
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Stok wajib diisi' : null,
            ),
            _input(
              controller: _kategoriController,
              label: 'Kategori',
              icon: Icons.category,
              validator: (v) => v!.isEmpty ? 'Kategori wajib diisi' : null,
            ),
            _input(
              controller: _deskripsiController,
              label: 'Deskripsi',
              icon: Icons.description,
              maxLines: 4,
              validator: (v) => v!.isEmpty ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: Text(isEdit ? 'Update Produk' : 'Simpan Produk'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final data = {
        'nama_barang': _namaController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
        'stok': _stokController.text.trim(),
        'harga': _hargaController.text.trim(),
        'kategori': _kategoriController.text.trim(),
      };

      final result = await _productService.insertToko(
        data,
        _imageFile,
        widget.product?.id,
      );

      if (mounted) {
        if (result.status == true) {
          AlertMassage().showAlert(context, result.message, true);
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context, true);
          });
        } else {
          AlertMassage().showAlert(context, result.message, false);
        }
      }
    } catch (e) {
      if (mounted) {
        AlertMassage().showAlert(context, 'Terjadi kesalahan: $e', false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              final result = await _productService.deleteToko(
                context,
                widget.product!.id,
              );
              if (mounted) {
                setState(() => _isLoading = false);
                if (result.status == true) {
                  AlertMassage().showAlert(context, result.message, true);
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) Navigator.pop(context, true);
                  });
                } else {
                  AlertMassage().showAlert(context, result.message, false);
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
