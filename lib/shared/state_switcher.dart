import 'package:flutter/material.dart';

class StateSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const StateSwitcher({super.key, required this.child, this.duration = const Duration(milliseconds: 350)});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          // Subtly scale from 98% to 100% for a "pop-in" effect
          child: ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation), child: child),
        );
      },
      child: child,
    );
  }
}
