import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/helpers/formatters/date_formatters.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';

class PaymentTile extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentTile(this.payment);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: BaseAppColors.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_rounded, color: BaseAppColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pago de Cuota',
                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  payment.createdAt.toShortDate(),
                  style: GoogleFonts.raleway(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          AmountText.fromCents(
            payment.amountInCents,
            fontSize: 16,
            color: BaseAppColors.secondary,
          ),
        ],
      ),
    );
  }
}