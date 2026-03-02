import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';

class PaymentColors {
  /// Returns the appropriate theme color based on the [PaymentStatus].
  /// This ensures that if the app theme changes (e.g. Dark Mode),
  /// the status colors update automatically.
  static Color getColor(BuildContext context, PaymentEntity payment) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (payment.status) {
      case PaymentStatus.approved:
        // Maps to AppColors.success
        return Colors.green.shade600;
      case PaymentStatus.pendingReview:
        // Maps to AppColors.warning (Amber)
        return Colors.amber.shade700;
      case PaymentStatus.cancelled:
        // Maps to AppColors.danger (Terracotta/Red)
        return colorScheme.error;
      case PaymentStatus.unknown:
        // Maps to AppColors.info (System Blue)
        return colorScheme.tertiary;
    }
  }
}
