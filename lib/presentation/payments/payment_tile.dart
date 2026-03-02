import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentTile extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentTile(this.payment, {super.key});

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
              color: AppColors.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.secondary),
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
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}