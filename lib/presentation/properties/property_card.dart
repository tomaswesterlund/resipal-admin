import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/properties/property_details/property_details_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  const PropertyCard(this.property);

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF1A4644);
    final bool hasDebt = property.hasDebt;
    final Color statusColor = hasDebt ? AppColors.danger : AppColors.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.1), width: 1),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText.five(property.name, color: themeColor),
                                Text(
                                  property.resident?.name ?? 'Sin residente asignado',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            hasDebt ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                            color: statusColor,
                            size: 22,
                          ),
                        ],
                      ),
                      const Divider(height: 12, thickness: 1, color: Color(0xFFF4F5F4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasDebt ? 'Deuda acumulada' : 'Al día',
                                style: GoogleFonts.raleway(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey400,
                                ),
                              ),
                              AmountText.fromCents(
                                property.totalOverdueFeeInCents,
                                fontSize: 18,
                                color: AppColors.grey800,
                              ),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: themeColor,
                              textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () => Go.to(PropertyDetailsPage(propertyId: property.id)),
                            child: const Row(
                              children: [Text('Detalles'), SizedBox(width: 4), Icon(Icons.arrow_forward_ios, size: 12)],
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
