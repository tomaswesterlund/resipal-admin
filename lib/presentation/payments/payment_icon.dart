import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';

class PaymentIcon extends StatelessWidget {
  final PaymentEntity payment;
  final double size;

  const PaymentIcon(this.payment, {this.size = 24, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor = _getStatusColor(context);

    return Container(
      padding: EdgeInsets.all(size * 0.6), // Proportional padding
      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(Icons.receipt_long_rounded, size: size, color: statusColor),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (payment.status) {
      case PaymentStatus.approved:
        // Resipal Green / Success
        return Colors.green.shade600;
      case PaymentStatus.pendingReview:
        // Admin Warning / Secondary (Terracotta)
        return colorScheme.secondary;
      case PaymentStatus.cancelled:
        // Error / Danger
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }
}
