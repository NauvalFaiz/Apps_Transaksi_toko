import 'package:flutter/material.dart';
import 'buttons.dart';

class DarkDialog extends StatelessWidget {
  final String message;
  final bool status;

  const DarkDialog({
    super.key,
    required this.message,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status ? 'Berhasil' : 'Gagal',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(message,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            outlineBtn('Tutup', () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}