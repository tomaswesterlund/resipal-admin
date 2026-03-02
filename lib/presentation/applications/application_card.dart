import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/applications/application_status_badge.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/extensions/formatters/date_formatters.dart';
import 'package:wester_kit/ui/texts/header_text.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;

  const ApplicationCard({required this.application, super.key});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(application.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
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
                                  'Solicitud de ingreso',
                                  style: GoogleFonts.raleway(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey400,
                                  ),
                                ),
                                HeaderText.six(application.name, color: AppColors.grey800),
                              ],
                            ),
                          ),
                          Icon(_getStatusIcon(application.status), color: statusColor, size: 20),
                        ],
                      ),

                      // Contact Info
                      const SizedBox(height: 8),
                      _buildContactRow(Icons.email_outlined, application.email),
                      const SizedBox(height: 4),
                      _buildContactRow(Icons.phone_outlined, application.phoneNumber),

                      const Divider(height: 24, thickness: 1, color: Color(0xFFF4F5F4)),

                      // Message snippet if exists
                      if (application.message != null && application.message!.trim().isNotEmpty) ...[
                        Text(
                          application.message!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 12),
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
                              const SizedBox(height: 6),
                              Text(
                                'Enviada el ${application.createdAt.toShortDate()}',
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.grey800,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () {
                              // Go.to(ApplicationDetailsPage(application: application));
                            },
                            child: const Row(
                              children: [Text('Ver más'), SizedBox(width: 4), Icon(Icons.arrow_forward_ios, size: 12)],
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

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey400),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.grey600),
        ),
      ],
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.approved:
        return AppColors.success;
      case ApplicationStatus.pendingReview:
        return AppColors.warning;
      case ApplicationStatus.rejected:
      case ApplicationStatus.revoked:
        return AppColors.danger;
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
