import 'package:flutter/material.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  OverlayEntry? _entry;
  bool _isShowing = false;

  void showToast(BuildContext context, String message,
      {IconData? icon, Color? color, Duration duration = const Duration(seconds: 2)}) {
    if (_isShowing) return;

    _isShowing = true;

    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: color ?? Colors.amberAccent, size: 22),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_entry!);

    Future.delayed(duration, hideToast);
  }

  void hideToast() {
    if (_entry != null) {
      _entry!.remove();
      _entry = null;
      _isShowing = false;
    }
  }
}
