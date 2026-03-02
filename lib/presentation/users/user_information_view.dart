import 'package:flutter/material.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class UserInformationView extends StatelessWidget {
  final UserEntity user;

  const UserInformationView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // --- Profile Section ---
        HeaderText.five('Perfil del Usuario'),
        const SizedBox(height: 12),
        _buildInfoContainer(context, [
          _buildDetailRow(context, Icons.email_outlined, 'Correo electrónico', user.email),
          _buildDetailRow(context, Icons.calendar_today_outlined, 'Miembro desde', user.createdAt.toShortDate()),
          _buildDetailRow(context, Icons.fingerprint_outlined, 'ID de Usuario', user.id.substring(0, 8).toUpperCase()),
        ]),

        const SizedBox(height: 24),

        // --- Roles Section ---
        HeaderText.five('Roles en la Comunidad'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (user.isAdmin) _buildRoleChip(context, 'Administrador', Icons.admin_panel_settings, colorScheme.primary),
            if (user.isResident) _buildRoleChip(context, 'Residente', Icons.home_outlined, Colors.green.shade600),
            if (user.isSecurity) _buildRoleChip(context, 'Seguridad', Icons.shield_outlined, colorScheme.tertiary),
          ],
        ),

        const SizedBox(height: 24),

        // --- Financial Summary Section ---
        HeaderText.five('Resumen Financiero'),
        const SizedBox(height: 12),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _buildFinancialStat(
              context,
              'Balance Total',
              user.paymentLedger.totalBalanceInCents,
              Colors.green.shade600,
            ),
            _buildFinancialStat(
              context,
              'Deuda Actual',
              user.propertyRegistery.totalOverdueFeeInCents.toInt(),
              user.propertyRegistery.hasDebt ? colorScheme.error : colorScheme.outline,
            ),
          ],
        ),

        const SizedBox(height: 96),
      ],
    );
  }

  // --- Helper Builders ---

  Widget _buildInfoContainer(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialStat(BuildContext context, String label, int cents, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.5,
              color: colorScheme.outline,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          AmountText.fromCents(cents, fontSize: 18, color: color),
        ],
      ),
    );
  }

  Widget _buildRoleChip(BuildContext context, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
