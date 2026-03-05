import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/members/member_details/member_details_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/lib.dart';

class MemberCard extends StatelessWidget {
  final MemberEntity member;

  const MemberCard(this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Financial Logic from Entity
    // Assuming MemberEntity or UserRef provides these values via resipal_core
    final bool hasDebt = member.propertyRegistry.hasDebt;
    final Color statusColor = hasDebt ? colorScheme.error : colorScheme.tertiary;

    // Property Label Logic: "Casa 1, Casa 2 y Casa 3"
    final List<String> propertyNames = member.propertyRegistry.properties.map((p) => p.name).toList();
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
              // Branded Status Indicator (Green for good, Red for debt)
              Container(width: 6, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header: Name & Role Icons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderText.five(member.name, color: colorScheme.onSurface),
                                const SizedBox(height: 2),
                                Text(
                                  propertiesLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildRoleBadges(context),
                        ],
                      ),

                      const Divider(height: 24, thickness: 1),

                      // --- Footer: Financial Metrics ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildAmountColumn(
                                  context,
                                  label: 'BALANCE',
                                  cents: member.paymentLedger.totalBalanceInCents,
                                  color: colorScheme.tertiary, // Success Green
                                ),
                                const SizedBox(width: 12),
                                _buildAmountColumn(
                                  context,
                                  label: 'PENDIENTE',
                                  cents: member.paymentLedger.pendingPaymentAmountInCents,
                                  color: colorScheme.secondary, // Amber/Terracotta
                                ),
                                const SizedBox(width: 12),
                                _buildAmountColumn(
                                  context,
                                  label: 'DEUDA',
                                  cents: member.propertyRegistry.totalOverdueFeeInCents.toInt(),
                                  color: hasDebt ? colorScheme.error : colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),

                          
                          ActionLink(
                            label: 'Detalles',
                            onTap: () => Go.to(MemberDetailsPage(member: member)),
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

  Widget _buildAmountColumn(BuildContext context, {required String label, required int cents, required Color color}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.outline,
          ),
        ),
        AmountText.fromCents(cents, fontSize: 13, color: color),
      ],
    );
  }

  Widget _buildRoleBadges(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      children: [
        if (member.isAdmin) _buildSmallIcon(Icons.admin_panel_settings, iconColor),
        if (member.isSecurity) _buildSmallIcon(Icons.shield_outlined, iconColor),
        if (member.isResident) _buildSmallIcon(Icons.home_work_outlined, iconColor),
      ],
    );
  }

  Widget _buildSmallIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
