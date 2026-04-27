import 'package:flutter/material.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_product.dart';
import 'package:flutter_mobile_modul/Apps/core/models/models_respont_data_list.dart';
import 'package:flutter_mobile_modul/Apps/core/service/service_product.dart';

class TokoProvider extends ChangeNotifier {
  final ServiceProduct _service = ServiceProduct();

  // ================= STATE =================
  List<ModelsProduct> _tokoList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ================= GETTER =================
  List<ModelsProduct> get tokoList => _tokoList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ================= CLEAR ERROR =================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ================= FETCH DATA =================
  Future<void> fetchToko() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      ModelsRespontDataList response = await _service.getToko();

      if (response.status == true) {
        // Pastikan data tidak null
        if (response.data != null) {
          _tokoList = List<ModelsProduct>.from(
            response.data as Iterable<dynamic>,
          );
        } else {
          _tokoList = [];
        }
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================= INSERT =================
  Future<bool> insertProduct({
    required Map<String, dynamic> data,
    dynamic image,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.insertToko(data, image, null);

      if (result.status == true) {
        await fetchToko(); // refresh data
        return true;
      } else {
        _errorMessage = result.message;
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error insert: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE =================
  Future<bool> updateProduct({
    required int id,
    required Map<String, dynamic> data,
    dynamic image,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.insertToko(data, image, id);

      if (result.status == true) {
        await fetchToko(); // refresh
        return true;
      } else {
        _errorMessage = result.message;
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error update: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= DELETE =================
  Future<bool> deleteProduct(int id) async {
    try {
      final result = await _service.deleteToko(null, id);

      if (result.status == true) {
        _tokoList.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error delete: $e';
      notifyListeners();
      return false;
    }
  }

  // ================= REFRESH =================
  Future<void> refresh() async {
    await fetchToko();
  }
}
