import 'dart:ui';

import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';

class PaymentColors {
  static Color getColor(PaymentEntity payment) {
    switch (payment.status) {
      case PaymentStatus.approved:
        return AppColors.success;
      case PaymentStatus.pendingReview:
        return AppColors.warning;
      case PaymentStatus.cancelled:
        return AppColors.danger;
      case PaymentStatus.unknown:
        return AppColors.info;
    }
  }
}
