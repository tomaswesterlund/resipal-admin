import 'package:flutter/material.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/presentation/shared/colors/payment_colors.dart';

class PaymentIcon extends StatelessWidget {
  final PaymentEntity payment;
  final double size;
  const PaymentIcon(this.payment, {this.size = 48, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaymentColors.getColor(payment).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.receipt_long_rounded,
        size: size,
        color: PaymentColors.getColor(payment),
      ),
    );
  }
}
