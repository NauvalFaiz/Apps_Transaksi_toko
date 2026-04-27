import 'package:flutter/material.dart';
import 'buttons.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hapus Data?',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              'Yakin ingin hapus?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: outlineBtn(
                    'Batal',
                        () => Navigator.pop(context, {'status': false}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: fillBtn(
                    'Hapus',
                    Colors.red,
                        () => Navigator.pop(context, {'status': true}),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}