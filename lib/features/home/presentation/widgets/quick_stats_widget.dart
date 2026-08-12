import 'package:flutter/material.dart';
import 'package:online_course/core/constants/app_colors.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.book_rounded,
            value: '5',
            label: 'Enrolled',
            gradient: const LinearGradient(
              colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFF4776E6),
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _StatChip(
            icon: Icons.schedule_rounded,
            value: '48h',
            label: 'Watched',
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8C42), Color(0xFFE6550A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFFE6550A),
            isDark: isDark,
          ),
          const SizedBox(width: 10),
          _StatChip(
            icon: Icons.local_fire_department_rounded,
            value: '12',
            label: 'Day Streak',
            gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            accentColor: const Color(0xFF11998E),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final LinearGradient gradient;
  final Color accentColor;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_StatChip> createState() => _StatChipState();
}

class _StatChipState extends State<_StatChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark ? AppColors.darkSurface : AppColors.white;

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) => _ctrl.forward(),
        onTapCancel: () => _ctrl.forward(),
        child: ScaleTransition(
          scale: _ctrl,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: widget.accentColor.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: widget.accentColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.getSecondaryTextColor(context),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
