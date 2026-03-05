import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/home/maintenance/maintenance_status_pill.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class MaintenanceFeeCard extends StatelessWidget {
  final MaintenanceFeeEntity fee;

  const MaintenanceFeeCard(this.fee, {super.key});

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (fee.status) {
      case MaintenanceFeeStatus.paid:
        return Colors.green; // Standard success color
      case MaintenanceFeeStatus.overdue:
        return colorScheme.error;
      case MaintenanceFeeStatus.pending:
        return Colors.orange;
      case MaintenanceFeeStatus.upcoming:
        return colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Status Indicator Side Bar
                Container(width: 5, color: statusColor),

                // 2. Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        // Left Side: Period and Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeaderText.five(
                                DateFormatters.toDateRange(fee.fromDate, fee.toDate),
                                color: colorScheme.onSurface,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Vence el ${fee.dueDate.toShortDate()}',
                                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                              if (fee.note != null && fee.note!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  fee.note!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Right Side: Amount and Status Pill
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AmountText.fromCents(fee.amountInCents, fontSize: 17, color: colorScheme.onSurface),
                            const SizedBox(height: 6),
                            MaintenanceStatusPill(fee),
                          ],
                        ),
                        const SizedBox(width: 12.0),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.outlineVariant),
                      ],
                    ),
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
