import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview_cubit.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview_state.dart';
import 'package:wester_kit/lib.dart';

class HomeOverview extends StatelessWidget {
  final VoidCallback onPendingPaymentsPressed;
  final VoidCallback onPendingApplicationsPressed;

  const HomeOverview({required this.onPendingPaymentsPressed, required this.onPendingApplicationsPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => HomeOverviewCubit()..initialize(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: BlocBuilder<HomeOverviewCubit, HomeOverviewState>(
          builder: (context, state) {
            if (state is LoadingState) return const LoadingView();
            if (state is ErrorState) return const ErrorView();

            if (state is LoadedState) {
              final community = state.community;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  HeaderText.four('¡Bienvenido, ${state.user.name}!'),
                  const SizedBox(height: 4),
                  Text(
                    community.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Metric Grid ---
                  GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        context,
                        'Propiedades',
                        community.propertyRegistry.count.toString(),
                        Icons.home_work_outlined,
                      ),
                      _buildStatCard(
                        context,
                        'Usuarios',
                        community.userDirectory.length.toString(),
                        Icons.people_outline,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Action Required Section ---
                  HeaderText.five('Acciones Pendientes'),
                  const SizedBox(height: 12),

                  _buildActionTile(
                    context,
                    title: 'Pagos por revisar',
                    count: community.paymentLedger.pendingPayments.length,
                    icon: Icons.receipt_long_outlined,
                    // Replaces AppColors.warning with Terracotta/Secondary
                    color: colorScheme.secondary,
                    onPressed: onPendingPaymentsPressed,
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    context,
                    title: 'Solicitudes de ingreso',
                    count: community.userDirectory.pendingApplications.length,
                    icon: Icons.person_add_outlined,
                    // Replaces AppColors.info with System/Info Tertiary
                    color: colorScheme.tertiary,
                    onPressed: onPendingApplicationsPressed,
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontFamily: 'NotoSansMono', // Consistent with numeric guide
                ),
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: count > 0 ? color : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
