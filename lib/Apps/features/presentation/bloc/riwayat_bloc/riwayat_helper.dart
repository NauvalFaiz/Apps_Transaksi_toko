import 'package:flutter/material.dart';

class RiwayatHelper {
  static String formatRupiah(int value) {
    final s = value.toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String formatDate(String dateTime) {
    if (dateTime.isEmpty) return '-';
    try {
      final DateTime parsed = DateTime.parse(dateTime);
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (e) {
      return dateTime;
    }
  }

  static bool isToday(String dateTime) {
    if (dateTime.isEmpty) return false;
    try {
      final DateTime parsed = DateTime.parse(dateTime);
      final now = DateTime.now();
      return parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day;
    } catch (e) {
      return false;
    }
  }

  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'processed':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return 'Selesai';
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}