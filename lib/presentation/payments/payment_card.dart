import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/payments/payment_details/payment_details_page.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/enums/payment_status.dart';
import 'package:resipal_core/helpers/formatters/date_formatters.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/colors/payment_colors.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';
import 'package:short_navigation/short_navigation.dart';

class PaymentCard extends StatelessWidget {
  final PaymentEntity payment;

  const PaymentCard(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = PaymentColors.getColor(payment);
    final bool isApproved = payment.status == PaymentStatus.approved;

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
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Reference & Status Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monto pagado',
                                style: GoogleFonts.raleway(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: BaseAppColors.auxiliarScale[400],
                                ),
                              ),
                              AmountText.fromCents(
                                payment.amountInCents,
                                fontSize: 18,
                                color: isApproved ? BaseAppColors.secondary : BaseAppColors.auxiliarScale[800]!,
                              ),
                            ],
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

                      // Text(
                      //   payment.note ?? 'Comprobante de pago adjunto',
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: GoogleFonts.raleway(color: AppColors.auxiliarScale[500], fontSize: 13),
                      // ),
                      const Divider(height: 12, thickness: 1, color: Color(0xFFF4F5F4)),

                      // Footer: Status, Date & Amount
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
                                  style: GoogleFonts.raleway(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              Text(
                                'Fecha de pago: ${payment.date.toShortDate()}',
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BaseAppColors.auxiliarScale[600],
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: BaseAppColors.secondary,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () => Go.to(PaymentDetailsPage(paymentId: payment.id)),
                            child: const Row(
                              children: [Text('Detalles'), SizedBox(width: 4), Icon(Icons.arrow_forward_ios, size: 12)],
                            ),
                          ),

                          // Right side: Amount
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
}
