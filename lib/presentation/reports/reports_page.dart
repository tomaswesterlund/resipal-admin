import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/reports/member_breakdown_report/member_breakdown_report_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/lib.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: const MyAppBar(title: 'Reportes'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Full Directory Report
            _ReportCard(
              title: 'Desglose de Miembros',
              description:
                  'Listado detallado de la comunidad con desglose de propiedades. Incluye balances totales, pagos por revisar y un estado de cuenta individualizado por cada predio vinculado.',
              icon: Icons.people_alt_rounded,
              iconColor: colorScheme.primary,
              onTap: () => Go.to(MemberBreakdownReportPage()),
            ),

            // const SizedBox(height: 16),

            // // 2. Debtors Only Report
            // _ReportCard(
            //   title: 'Reporte de Morosos',
            //   description:
            //       'Filtrado exclusivo de residentes con adeudos vencidos. Detalla el monto total de la deuda por propiedad y meses de atraso.',
            //   icon: Icons.assignment_late_rounded,
            //   iconColor: colorScheme.error,
            //   onTap: () => Go.to(MemberBreakdownReportPage(onlyDebtors: true)),
            // ),

            const SizedBox(height: 32),

            // Helpful tip for the Admin
            _buildInfoBox(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Los reportes se generan en tiempo real basados en la información más reciente de la administración.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  HeaderText.five(title, color: colorScheme.onSurface),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.inverseSurface, height: 1.4),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BodyText.small('Ver reporte', color: colorScheme.primary, fontWeight: FontWeight.bold),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_outlined, size: 14, color: colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
