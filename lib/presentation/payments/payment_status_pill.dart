import 'package:flutter/widgets.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/enums/payment_status.dart';
import 'package:resipal_core/presentation/shared/colors/payment_colors.dart';

class PaymentStatusPill extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentStatusPill(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: PaymentColors.getColor(payment).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getLabel().toUpperCase(),
        style: TextStyle(
          color: PaymentColors.getColor(payment),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          fontSize: 12,
        ),
      ),
    );
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
