import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';

class ApplicationStatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const ApplicationStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color color;
    final String text;

    switch (status) {
      case ApplicationStatus.pendingReview:
        // Using Secondary (Terracotta/Warm Green) for pending actions
        color = colorScheme.secondary;
        text = 'Pendiente';
      case ApplicationStatus.approved:
        // Resipal Green / Success
        color = Colors.green.shade600;
        text = 'Aprobada';
      case ApplicationStatus.rejected:
        color = colorScheme.error;
        text = 'Rechazada';
      default:
        color = colorScheme.outline;
        text = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
