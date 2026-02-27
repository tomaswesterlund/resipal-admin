import 'package:flutter/widgets.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';

class ApplicationStatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const ApplicationStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case ApplicationStatus.pendingReview:
        color = AppColors.warning;
        text = 'Pendiente';
      case ApplicationStatus.approved:
        color = AppColors.success;
        text = 'Aprobada';
      case ApplicationStatus.rejected:
        color = AppColors.danger;
        text = 'Rechazada';
      default:
        color = AppColors.grey400;
        text = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
