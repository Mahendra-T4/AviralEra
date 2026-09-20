import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';

enum ToastType { success, error, warning, info }

class ToastUtils {
  static OverlayEntry? _currentEntry;

  static void showToast(
    BuildContext context,
    ToastType type,
    Color? textColor, {
    required String message,
    IconData? icon,
    int? maxLines,
  }) {
    final String cleanMessage = message.trim();
    if (cleanMessage.isEmpty || cleanMessage == 'null') return;

    // Immediately remove any active toast before showing the new one
    if (_currentEntry != null) {
      try {
        if (_currentEntry!.mounted) {
          _currentEntry!.remove();
        }
      } catch (_) {}
      _currentEntry = null;
    }

    Color bgColor;
    Color fgColor = textColor ?? Colors.white;
    IconData defaultIcon;

    switch (type) {
      case ToastType.success:
        bgColor = AppColors.successDark;
        defaultIcon = Icons.check_circle_outline_rounded;
        break;
      case ToastType.error:
        bgColor = AppColors.errorDark;
        defaultIcon = Icons.error_outline_rounded;
        break;
      case ToastType.warning:
        bgColor = AppColors.warningDark;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case ToastType.info:
        bgColor = AppColors.infoDark;
        defaultIcon = Icons.info_outline_rounded;
        break;
    }

    try {
      final overlay =
          Overlay.maybeOf(context, rootOverlay: true) ??
          Overlay.maybeOf(context);
      if (overlay == null) return;

      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (ctx) => _TopToastWidget(
          message: cleanMessage,
          bgColor: bgColor,
          fgColor: fgColor,
          icon: icon ?? defaultIcon,
          maxLines: maxLines,
          onDismiss: () {
            if (_currentEntry == entry) {
              _currentEntry = null;
            }
            try {
              if (entry.mounted) {
                entry.remove();
              }
            } catch (_) {}
          },
        ),
      );

      _currentEntry = entry;
      overlay.insert(entry);
    } catch (_) {}
  }
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final Color bgColor;
  final Color fgColor;
  final IconData icon;
  final VoidCallback onDismiss;
  final int? maxLines;

  const _TopToastWidget({
    required this.message,
    required this.bgColor,
    required this.fgColor,
    required this.icon,
    required this.onDismiss,
    this.maxLines,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, -0.8), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 10), () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (_isDismissed) return;
    _isDismissed = true;

    if (!mounted) {
      widget.onDismiss();
      return;
    }

    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 14,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _dismiss,
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta != null &&
                    details.primaryDelta! < -3) {
                  _dismiss();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.fgColor, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        maxLines: widget.maxLines,
                        style: TextStyle(
                          color: widget.fgColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
