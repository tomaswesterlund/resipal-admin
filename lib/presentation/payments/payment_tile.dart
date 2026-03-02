import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentTile extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentTile(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // Branded Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded, 
              color: colorScheme.secondary, 
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pago de Cuota',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  payment.createdAt.toShortDate(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Currency Display using Mono Font via AmountText
          AmountText.fromCents(
            payment.amountInCents,
            fontSize: 16,
            color: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}