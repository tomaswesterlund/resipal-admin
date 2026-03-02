import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class UserInformationView extends StatelessWidget {
  final MembershipEntity membership;

  const UserInformationView({super.key, required this.membership});

  @override
  Widget build(BuildContext context) {
    final resident = membership.resident;
    final user = resident.user;
    final ledger = resident.paymentLedger;
    final registry = resident.propertyRegistery;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // --- Profile Section ---
        HeaderText.five('Perfil del Usuario'),
        const SizedBox(height: 12),
        _buildInfoContainer([
          _buildDetailRow(Icons.email_outlined, 'Correo electrónico', user.email),
          _buildDetailRow(Icons.calendar_today_outlined, 'Miembro desde', membership.createdAt.toShortDate()),
          _buildDetailRow(Icons.fingerprint_outlined, 'ID de Usuario', user.id.substring(0, 8).toUpperCase()),
        ]),

        const SizedBox(height: 24),

        // --- Roles Section ---
        HeaderText.five('Roles en la Comunidad'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (membership.isAdmin) _buildRoleChip('Administrador', Icons.admin_panel_settings, AppColors.primary),
            if (membership.isResident) _buildRoleChip('Residente', Icons.home_outlined, AppColors.success),
            if (membership.isSecurity) _buildRoleChip('Seguridad', Icons.shield_outlined, AppColors.info),
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
            _buildFinancialStat('Balance Total', ledger.totalBalanceInCents, AppColors.success),
            _buildFinancialStat(
              'Deuda Actual',
              registry.totalOverdueFeeInCents.toInt(),
              registry.hasDebt ? AppColors.danger : AppColors.grey400,
            ),
          ],
        ),

        const SizedBox(height: 96), // Space for navigation/FAB overlap
      ],
    );
  }

  // --- Helper Builders ---

  Widget _buildInfoContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.grey500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.raleway(fontSize: 13, color: AppColors.grey600, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialStat(String label, int cents, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.raleway(fontSize: 10, color: AppColors.grey500, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          AmountText.fromCents(cents, fontSize: 18, color: color),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.raleway(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
