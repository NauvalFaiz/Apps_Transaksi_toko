import 'package:flutter/material.dart';
import 'slide_toast.dart';
import 'dark_dialog.dart';
import 'confirm_dialog.dart';

class AlertMassage {
  void showAlert(
      BuildContext context,
      String message,
      bool status, {
        Duration? duration,
        VoidCallback? onClose,
      }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    bool closed = false;

    void close() {
      if (!closed) {
        closed = true;
        if (entry.mounted) entry.remove();
        onClose?.call();
      }
    }

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SlideToast(
            message: message,
            status: status,
            onClose: close,
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration ?? const Duration(seconds: 4), close);
  }

  void showSnackBarAlert(
      BuildContext context,
      String message,
      bool status,
      ) {
    final isSuccess = status;
    final _ = isSuccess
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Text(message),
      ),
    );
  }

  void showDialogAlert(
      BuildContext context,
      String message,
      bool status,
      ) {
    showDialog(
      context: context,
      builder: (_) => DarkDialog(
        message: message,
        status: status,
      ),
    );
  }

  Future<Map<String, dynamic>?> showAlertDialog(
      BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const ConfirmDialog(),
    );
  }
}