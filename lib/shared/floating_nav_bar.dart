import 'package:flutter/material.dart';
import 'package:resipal_admin/shared/app_colors.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<FloatingNavBarItem> items;
  final Function(int) onChanged;

  // Color Inputs
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color dangerColor;
  final Color warningColor;
  final Color infoColor;
  final Color badgeTextColor;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.items,
    this.backgroundColor = Colors.white,
    this.activeColor = AppColors.primary,
    this.inactiveColor = Colors.grey,
    this.dangerColor = AppColors.danger,
    this.warningColor = AppColors.warning,
    this.infoColor = AppColors.info,
    this.badgeTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onChanged(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(item.icon, color: isActive ? backgroundColor : inactiveColor, size: 24),
                    ),

                    // Badge Logic
                    if (item.showDanger || item.warningBadgeCount > 0 || item.badgeCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: _BadgeIndicator(
                          color: item.showDanger
                              ? dangerColor
                              : (item.warningBadgeCount > 0 ? warningColor : infoColor),
                          text: item.showDanger
                              ? '!'
                              : (item.warningBadgeCount > 0
                                    ? item.warningBadgeCount.toString()
                                    : item.badgeCount.toString()),
                          borderColor: backgroundColor,
                          textColor: badgeTextColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Internal helper for the circular badges
class _BadgeIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final Color borderColor;
  final Color textColor;

  const _BadgeIndicator({required this.color, required this.text, required this.borderColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: borderColor, shape: BoxShape.circle),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class FloatingNavBarItem {
  final IconData icon;
  final String label;
  final bool showDanger;
  final int warningBadgeCount;
  final int badgeCount;

  FloatingNavBarItem({
    required this.icon,
    required this.label,
    this.showDanger = false,
    this.warningBadgeCount = 0,
    this.badgeCount = 0,
  });
}
