import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resipal_admin/presentation/payments/payment_icon.dart';
import 'package:resipal_admin/presentation/payments/payment_status_pill.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/enums/payment_status.dart';
import 'package:resipal_core/helpers/formatters/currency_formatter.dart';
import 'package:resipal_core/presentation/shared/cards/default_card.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';

class PaymentHeader extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentHeader(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultCard(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                PaymentIcon(payment),
                const SizedBox(height: 16),
                AmountText(CurrencyFormatter.fromCents(payment.amountInCents)),
                const SizedBox(height: 8),
                PaymentStatusPill(payment),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
