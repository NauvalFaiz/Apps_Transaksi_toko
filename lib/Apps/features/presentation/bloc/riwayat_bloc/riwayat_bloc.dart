import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile_modul/Apps/core/service/service_user.dart';
import 'package:flutter_mobile_modul/Apps/features/presentation/bloc/riwayat_bloc/riwayat_event.dart';

import '../../../../core/models/models_riwayatTransaksi.dart';

part 'riwayat_state.dart';

class RiwayatBloc extends Bloc<RiwayatEvent, RiwayatState> {
  final ServiceUser _service;

  RiwayatBloc({required ServiceUser service})
    : _service = service,
      super(RiwayatInitial()) {
    on<LoadRiwayat>(_onLoadRiwayat);
    on<RefreshRiwayat>(_onRefreshRiwayat);
    on<LoadDetailTransaksi>(_onLoadDetailTransaksi);
  }

  Future<void> _onLoadRiwayat(
    LoadRiwayat event,
    Emitter<RiwayatState> emit,
  ) async {
    emit(RiwayatLoading());

    final response = await _service.getRiwayatTransaksi();

    if (response.status && response.data.isNotEmpty) {
      // 🔥 Urutkan berdasarkan tanggal terbaru (descending)
      final sortedData = List<RiwayatTransaksi>.from(response.data);
      sortedData.sort((a, b) => b.tglTransaksi.compareTo(a.tglTransaksi));
      
      emit(RiwayatLoaded(riwayat: sortedData));
    } else if (response.status && response.data.isEmpty) {
      emit(RiwayatLoaded(riwayat: []));
    } else {
      emit(RiwayatError(response.message));
    }
  }

  Future<void> _onRefreshRiwayat(
    RefreshRiwayat event,
    Emitter<RiwayatState> emit,
  ) async {
    final response = await _service.getRiwayatTransaksi();

    if (response.status) {
      // 🔥 Urutkan berdasarkan tanggal terbaru (descending)
      final sortedData = List<RiwayatTransaksi>.from(response.data);
      sortedData.sort((a, b) => b.tglTransaksi.compareTo(a.tglTransaksi));
      
      emit(RiwayatLoaded(riwayat: sortedData));
    } else {
      emit(RiwayatError(response.message));
    }
  }

  Future<void> _onLoadDetailTransaksi(
    LoadDetailTransaksi event,
    Emitter<RiwayatState> emit,
  ) async {
    emit(DetailTransaksiLoading());

    final transaksi = await _service.getDetailTransaksi(event.idTransaksi);

    if (transaksi != null) {
      emit(DetailTransaksiLoaded(transaksi));
    } else {
      emit(const DetailTransaksiError('Gagal memuat detail transaksi'));
    }
  }
}
