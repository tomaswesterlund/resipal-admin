import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/applications/application_status_badge.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;

  const ApplicationCard({required this.application, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color statusColor = _getStatusColor(context, application.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Accent Bar
              Container(width: 6, color: statusColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Name & Status Icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SOLICITUD DE INGRESO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: colorScheme.outline,
                                  ),
                                ),
                                HeaderText.six(application.name, color: colorScheme.onSurface),
                              ],
                            ),
                          ),
                          Icon(_getStatusIcon(application.status), color: statusColor, size: 20),
                        ],
                      ),

                      // Contact Info
                      const SizedBox(height: 12),
                      _buildContactRow(context, Icons.email_outlined, application.email),
                      const SizedBox(height: 4),
                      _buildContactRow(context, Icons.phone_outlined, application.phoneNumber),

                      Divider(height: 32, thickness: 1, color: colorScheme.outlineVariant),

                      // Message snippet
                      if (application.message != null && application.message!.trim().isNotEmpty) ...[
                        Text(
                          '"${application.message!}"',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Footer: Badge & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ApplicationStatusBadge(status: application.status),
                              const SizedBox(height: 8),
                              Text(
                                'Enviada: ${application.createdAt.toShortDate()}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.outline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          // Clean Action Button
                          GestureDetector(
                            onTap: () {
                              // Go.to(ApplicationDetailsPage(application: application));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    'Ver más',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios, size: 12, color: colorScheme.primary),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.outline),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, ApplicationStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case ApplicationStatus.approved:
        return Colors.green.shade600;
      case ApplicationStatus.pendingReview:
        return colorScheme.secondary; // Branded Warning
      case ApplicationStatus.rejected:
      case ApplicationStatus.revoked:
        return colorScheme.error;
    }
  }

  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.approved:
        return Icons.check_circle_outline;
      case ApplicationStatus.pendingReview:
        return Icons.schedule_rounded;
      case ApplicationStatus.rejected:
        return Icons.block_flipped;
      case ApplicationStatus.revoked:
        return Icons.history;
    }
  }
}