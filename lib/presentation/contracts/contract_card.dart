import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/shared/app_colors.dart';
import 'package:resipal_core/domain/entities/contract_entity.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';

class ContractCard extends StatelessWidget {
  final ContractEntity contract;
  const ContractCard(this.contract);

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF1A4644);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withOpacity(0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: themeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText.five(contract.name, color: themeColor),
                                Text(
                                  contract.period, // Ej: "Mensual" or "Anual"
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.auxiliarScale[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.assignment_outlined, color: themeColor, size: 20),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFF4F5F4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monto de la cuota',
                                style: GoogleFonts.raleway(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.auxiliarScale[400],
                                ),
                              ),
                              AmountText.fromCents(contract.amountInCents, fontSize: 18, color: AppColors.secondary),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: themeColor,
                              textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () {
                              // Details logic
                            },
                            child: const Row(
                              children: [
                                Text('Gestionar'),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
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
}
