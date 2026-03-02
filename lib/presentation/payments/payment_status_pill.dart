import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';

class PaymentStatusPill extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentStatusPill(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor = _getStatusColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Text(
        _getLabel().toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          fontSize: 10,
        ),
      ),
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
      case PaymentStatus.unknown:
        return colorScheme.outline;
    }
  }

  String _getLabel() {
    switch (payment.status) {
      case PaymentStatus.approved:
        return 'Aprobado';
      case PaymentStatus.pendingReview:
        return 'En Revisión';
      case PaymentStatus.cancelled:
        return 'Cancelado';
      case PaymentStatus.unknown:
        return 'Desconocido';
    }
  }
}
