import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class ContractCard extends StatelessWidget {
  final ContractEntity contract;
  const ContractCard(this.contract, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              // Branded side accent
              Container(width: 6, color: colorScheme.primary),
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
                                HeaderText.five(contract.name, color: colorScheme.primary),
                                Text(
                                  contract.period.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.assignment_outlined, color: colorScheme.primary, size: 20),
                        ],
                      ),
                      Divider(height: 24, thickness: 1, color: colorScheme.outlineVariant),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MONTO DE LA CUOTA',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.outline,
                                ),
                              ),
                              AmountText.fromCents(contract.amountInCents, fontSize: 18, color: colorScheme.onSurface),
                            ],
                          ),
                          ActionLink(label: 'Detalles', onTap: () {}),
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
