part of 'riwayat_bloc.dart';

abstract class RiwayatState extends Equatable {
  const RiwayatState();

  @override
  List<Object?> get props => [];
}

class RiwayatInitial extends RiwayatState {}

class RiwayatLoading extends RiwayatState {}

class RiwayatLoaded extends RiwayatState {
  final List<RiwayatTransaksi> riwayat;

  const RiwayatLoaded({required this.riwayat});

  int get totalSpend => riwayat.fold(0, (sum, r) => sum + r.totalHarga);
  int get totalItems => riwayat.fold(0, (sum, r) => sum + r.totalItem);

  @override
  List<Object?> get props => [riwayat];
}

class RiwayatError extends RiwayatState {
  final String message;

  const RiwayatError(this.message);

  @override
  List<Object?> get props => [message];
}

// State untuk detail transaksi
class DetailTransaksiLoading extends RiwayatState {}

class DetailTransaksiLoaded extends RiwayatState {
  final RiwayatTransaksi transaksi;

  const DetailTransaksiLoaded(this.transaksi);

  @override
  List<Object?> get props => [transaksi];
}

class DetailTransaksiError extends RiwayatState {
  final String message;

  const DetailTransaksiError(this.message);

  @override
  List<Object?> get props => [message];
}