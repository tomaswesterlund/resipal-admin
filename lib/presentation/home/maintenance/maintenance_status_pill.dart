import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class MaintenanceStatusPill extends StatelessWidget {
  final MaintenanceFeeEntity maintenanceFee;
  const MaintenanceStatusPill(this.maintenanceFee, {super.key});

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (maintenanceFee.status) {
      case MaintenanceFeeStatus.paid:
        return Colors.green;
      case MaintenanceFeeStatus.overdue:
        return colorScheme.error;
      case MaintenanceFeeStatus.pending:
        return Colors.orange;
      case MaintenanceFeeStatus.upcoming:
        return colorScheme.outline;
    }
  }

  String _getLabel() {
    switch (maintenanceFee.status) {
      case MaintenanceFeeStatus.paid:
        return 'Pagado';
      case MaintenanceFeeStatus.pending:
        return 'Pendiente';
      case MaintenanceFeeStatus.overdue:
        return 'Vencido';
      case MaintenanceFeeStatus.upcoming:
        return 'Próximo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        // Adding a subtle border makes it look cleaner on various backgrounds
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: Text(
        _getLabel().toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w800, // Extra bold for that "Pill" look
          letterSpacing: 0.8,
          fontSize: 10,
        ),
      ),
    );
  }
}
