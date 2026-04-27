import 'package:flutter/material.dart';

class SlideToast extends StatefulWidget {
  final String message;
  final bool status;
  final VoidCallback onClose;

  const SlideToast({
    super.key,
    required this.message,
    required this.status,
    required this.onClose,
  });

  @override
  State<SlideToast> createState() => _SlideToastState();
}

class _SlideToastState extends State<SlideToast>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slide = Tween(begin: const Offset(0, -1), end: Offset.zero)
        .animate(_ctrl);

    _fade = Tween(begin: 0.0, end: 1.0).animate(_ctrl);

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(widget.message,
              style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}