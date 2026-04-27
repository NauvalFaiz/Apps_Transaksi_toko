import 'package:flutter/material.dart';

class ToastNotification {
  static void show(
      BuildContext context, String message, bool isSuccess) {

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 30,
        left: 20,
        right: 20,
        child: Material(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Text(message,
                style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);

    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}