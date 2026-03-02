import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/payments/payment_details/payment_details_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class PaymentCard extends StatelessWidget {
  final PaymentEntity payment;

  const PaymentCard(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor = _getStatusColor(context);
    final bool isApproved = payment.status == PaymentStatus.approved;

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
              // Side indicator bar
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Amount & Resident Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MONTO PAGADO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    AmountText.fromCents(
                                      payment.amountInCents,
                                      fontSize: 18,
                                      color: colorScheme.onSurface,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'de ${payment.user.name}',
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.outline,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isApproved
                                ? Icons.check_circle
                                : payment.status == PaymentStatus.pendingReview
                                ? Icons.schedule_rounded
                                : Icons.cancel_outlined,
                            color: statusColor,
                            size: 20,
                          ),
                        ],
                      ),

                      Divider(height: 24, thickness: 1, color: colorScheme.outlineVariant),

                      // Footer: Status Badge & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  payment.status.displayName.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Fecha: ${payment.date.toShortDate()}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.outline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () => Go.to(PaymentDetailsPage(paymentId: payment.id)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    'Detalles',
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

  Color _getStatusColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (payment.status) {
      case PaymentStatus.approved:
        return Colors.green.shade600;
      case PaymentStatus.pendingReview:
        return colorScheme.secondary;
      case PaymentStatus.cancelled:
        return colorScheme.error;
      default:
        return colorScheme.outline;
    }
  }
}
