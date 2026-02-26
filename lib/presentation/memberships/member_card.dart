import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_core/domain/entities/membership_entity.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';

class MembershipCard extends StatelessWidget {
  final MembershipEntity member;

  const MembershipCard(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasDebt = member.resident.propertyRegistery.hasDebt;
    final Color statusColor = hasDebt ? BaseAppColors.danger : BaseAppColors.secondary;

    // Property Label Logic (Stayed the same)
    final List<String> propertyNames = member.resident.propertyRegistery.properties.map((p) => p.name).toList();
    String propertiesLabel = 'Sin propiedades';
    if (propertyNames.isNotEmpty) {
      if (propertyNames.length == 1) {
        propertiesLabel = propertyNames.first;
      } else {
        final last = propertyNames.removeLast();
        propertiesLabel = '${propertyNames.join(', ')} y $last';
      }
    }

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
                      // Header: Member Name & Role Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText.five(member.resident.user.name, color: BaseAppColors.auxiliarScale[900]!),
                                const SizedBox(height: 2),
                                Text(
                                  propertiesLabel,
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: BaseAppColors.auxiliarScale[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildRoleBadges(),
                        ],
                      ),

                      const Divider(height: 24, thickness: 1, color: Color(0xFFF4F5F4)),

                      // Footer: Balance, Pending, and Debt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Financial Columns Group
                          Expanded(
                            child: Row(
                              children: [
                                _buildAmountColumn(
                                  label: 'Balance',
                                  cents: member.resident.paymentLedger.totalBalanceInCents,
                                  color: BaseAppColors.secondary,
                                ),
                                const SizedBox(width: 16), // Reduced from 24 to fit 3 items
                                _buildAmountColumn(
                                  label: 'Pendiente',
                                  // Added the pending amount here
                                  cents: member.resident.paymentLedger.pendingPaymentAmountInCents,
                                  color: BaseAppColors.warning,
                                ),
                                const SizedBox(width: 16),
                                _buildAmountColumn(
                                  label: 'Deuda',
                                  cents: member.resident.propertyRegistery.totalOverdueFeeInCents.toInt(),
                                  color: hasDebt ? BaseAppColors.danger : BaseAppColors.auxiliarScale[800]!,
                                ),
                              ],
                            ),
                          ),

                          // Right: Action
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: BaseAppColors.secondary,
                              padding: EdgeInsets.zero, // More compact for 3-column layout
                              textStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            onPressed: () {
                              // Go.to(MemberDetailsPage(memberId: member.id));
                            },
                            child: const Row(
                              children: [Text('Ver'), SizedBox(width: 2), Icon(Icons.arrow_forward_ios, size: 10)],
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

  Widget _buildAmountColumn({required String label, required int cents, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 9, // Slightly smaller to prevent overflow
            fontWeight: FontWeight.w700,
            color: BaseAppColors.auxiliarScale[400],
          ),
        ),
        AmountText.fromCents(
          cents,
          fontSize: 14, // Reduced from 16 to fit the 3rd column safely
          color: color,
        ),
      ],
    );
  }

  Widget _buildRoleBadges() {
    return Row(
      children: [
        if (member.isAdmin) _buildSmallIcon(Icons.admin_panel_settings, BaseAppColors.secondaryScale[400]!),
        if (member.isSecurity) _buildSmallIcon(Icons.shield_outlined, BaseAppColors.secondaryScale[400]!),
        if (member.isResident) _buildSmallIcon(Icons.home_work_outlined, BaseAppColors.secondaryScale[400]!),
      ],
    );
  }

  Widget _buildSmallIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
