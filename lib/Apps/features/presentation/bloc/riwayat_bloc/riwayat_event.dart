

import 'package:equatable/equatable.dart';

abstract class RiwayatEvent extends Equatable {
  const RiwayatEvent();

  @override
  List<Object?> get props => [];
}

class LoadRiwayat extends RiwayatEvent {}

class RefreshRiwayat extends RiwayatEvent {}

class LoadDetailTransaksi extends RiwayatEvent {
  final int idTransaksi;

  const LoadDetailTransaksi(this.idTransaksi);

  @override
  List<Object?> get props => [idTransaksi];
}