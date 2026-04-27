import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile_modul/Apps/core/service/service_user.dart';
import '../../../../../core/models/models_riwayatTransaksi.dart';
import '../../../bloc/riwayat_bloc/riwayat_bloc.dart';
import '../../../bloc/riwayat_bloc/riwayat_event.dart';
import '../../../bloc/riwayat_bloc/riwayat_helper.dart';

class UserRiwayatPage extends StatelessWidget {
  const UserRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RiwayatBloc(service: ServiceUser())..add(LoadRiwayat()),
      child: const _UserRiwayatPageView(),
    );
  }
}

class _UserRiwayatPageView extends StatefulWidget {
  const _UserRiwayatPageView();

  @override
  State<_UserRiwayatPageView> createState() => _UserRiwayatPageViewState();
}

class _UserRiwayatPageViewState extends State<_UserRiwayatPageView> {
  // Warna putih biru yang soft
  static const primaryBlue = Color(0xFF1976D2);
  static const lightBlue = Color(0xFFE3F2FD);
  static const softWhite = Color(0xFFFAFAFA);
  static const textDark = Color(0xFF212121);
  static const textGrey = Color(0xFF757575);
  static const dividerColor = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<RiwayatBloc>().add(RefreshRiwayat());
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<RiwayatBloc, RiwayatState>(
        builder: (context, state) {
          if (state is RiwayatLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryBlue),
            );
          } else if (state is RiwayatError) {
            return _buildError(state.message, context);
          } else if (state is RiwayatLoaded) {
            if (state.riwayat.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RiwayatBloc>().add(RefreshRiwayat());
              },
              color: primaryBlue,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.riwayat.length,
                itemBuilder: (context, index) {
                  return _buildTransactionCard(state.riwayat[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTransactionCard(RiwayatTransaksi transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDetailDialog(context, transaction),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: ID Transaksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'TRX-${transaction.idTransaksi}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ),
                  // Badge total item
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${transaction.totalItem} item',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tanggal
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: textGrey),
                  const SizedBox(width: 6),
                  Text(
                    RiwayatHelper.formatDate(transaction.tglTransaksi),
                    style: TextStyle(fontSize: 12, color: textGrey),
                  ),
                  if (RiwayatHelper.isToday(transaction.tglTransaksi)) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.green.withAlpha(50),
                        ),
                      ),
                      child: const Text(
                        'Hari Ini',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Nama User
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: textGrey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      transaction.namaUser,
                      style: TextStyle(fontSize: 12, color: textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Preview Item (max 2 item)
              if (transaction.detail.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: transaction.detail.take(2).map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.namaBarang,
                        style: TextStyle(fontSize: 11, color: primaryBlue),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),

              if (transaction.detail.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${transaction.detail.length - 2} item lainnya',
                    style: TextStyle(fontSize: 11, color: textGrey),
                  ),
                ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: dividerColor),
              const SizedBox(height: 10),

              // Footer: Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textGrey,
                    ),
                  ),
                  Text(
                    RiwayatHelper.formatRupiah(transaction.totalHarga),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, RiwayatTransaksi transaction) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _buildDetailDialog(transaction);
      },
    );
  }

  Widget _buildDetailDialog(RiwayatTransaksi transaction) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'TRX-${transaction.idTransaksi}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Informasi Transaksi
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: primaryBlue),
                      const SizedBox(width: 8),
                      Text(
                        RiwayatHelper.formatDate(transaction.tglTransaksi),
                        style: TextStyle(fontSize: 14, color: textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: primaryBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          transaction.namaUser,
                          style: TextStyle(fontSize: 14, color: textDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Item
            const Text(
              'Detail Produk',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: transaction.detail.length,
                separatorBuilder: (_, __) => const Divider(color: dividerColor),
                itemBuilder: (context, index) {
                  final item = transaction.detail[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaBarang,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity} x ${RiwayatHelper.formatRupiah(item.hargaBeli)}',
                                style: TextStyle(fontSize: 12, color: textGrey),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          RiwayatHelper.formatRupiah(item.subtotal),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(color: dividerColor),
            const SizedBox(height: 12),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      RiwayatHelper.formatRupiah(transaction.totalHarga),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    Text(
                      '${transaction.totalItem} item',
                      style: TextStyle(fontSize: 11, color: textGrey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: textGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Transaksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transaksimu akan muncul di sini',
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: textGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<RiwayatBloc>().add(LoadRiwayat());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
