import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/users/user_details/user_details_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/ui/texts/amount_text.dart';
import 'package:wester_kit/ui/texts/body_text.dart';
import 'package:wester_kit/ui/texts/header_text.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mapping states to Theme Colors
    final bool hasDebt = user.propertyRegistery.hasDebt;
    final Color statusColor = hasDebt ? colorScheme.error : Colors.green.shade600;

    // Property Label Logic
    final List<String> propertyNames = user.propertyRegistery.properties.map((p) => p.name).toList();

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
              // Branded Status Indicator
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
                                HeaderText.five(user.name, color: colorScheme.onSurface),
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

                      // Footer: Financial Metrics
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
                                  cents: user.paymentLedger.totalBalanceInCents,
                                  color: Colors.green.shade600,
                                ),
                                const SizedBox(width: 12),
                                _buildAmountColumn(
                                  context,
                                  label: 'PENDIENTE',
                                  cents: user.paymentLedger.pendingPaymentAmountInCents,
                                  color: colorScheme.secondary, // Secondary is our Warning/Amber scale
                                ),
                                const SizedBox(width: 12),
                                _buildAmountColumn(
                                  context,
                                  label: 'DEUDA',
                                  cents: user.propertyRegistery.totalOverdueFeeInCents.toInt(),
                                  color: hasDebt ? colorScheme.error : colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),

                          // Action Button
                          GestureDetector(
                            onTap: () => Go.to(UserDetailsPage(user)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  BodyText.small('Detalles', color: colorScheme.primary, fontWeight: FontWeight.bold),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios, size: 10, color: colorScheme.primary),
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
        AmountText.fromCents(
          cents,
          fontSize: 13,
          color: color,
        ),
      ],
    );
  }

  Widget _buildRoleBadges(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      children: [
        if (user.isAdmin) _buildSmallIcon(Icons.admin_panel_settings, iconColor),
        if (user.isSecurity) _buildSmallIcon(Icons.shield_outlined, iconColor),
        if (user.isResident) _buildSmallIcon(Icons.home_work_outlined, iconColor),
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