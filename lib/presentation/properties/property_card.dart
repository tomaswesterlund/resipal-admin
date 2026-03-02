import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/properties/property_details/property_details_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  const PropertyCard(this.property, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool hasDebt = property.hasDebt;
    // error for Debt (Terracotta), primary or green for healthy status
    final Color statusColor = hasDebt ? colorScheme.error : Colors.green.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visual status indicator bar
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
                                HeaderText.five(property.name, color: colorScheme.primary),
                                Text(
                                  property.resident?.name ?? 'Sin residente asignado',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.outline,
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
                      const Divider(height: 24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (hasDebt ? 'Deuda acumulada' : 'Al día').toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 9,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.outline,
                                ),
                              ),
                              const SizedBox(height: 2),
                              AmountText.fromCents(
                                property.totalOverdueFeeInCents,
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ],
                          ),
                          // Compact Detail Button
                          GestureDetector(
                            onTap: () => Go.to(PropertyDetailsPage(propertyId: property.id)),
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
}