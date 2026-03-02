import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview_cubit.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview_state.dart';
import 'package:wester_kit/lib.dart';

class HomeOverview extends StatelessWidget {
  final VoidCallback onPendingPaymentsPressed;
  final VoidCallback onPendingApplicationsPressed;
  const HomeOverview({required this.onPendingPaymentsPressed, required this.onPendingApplicationsPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeOverviewCubit()..initialize(),
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                    style: GoogleFonts.raleway(color: AppColors.grey600, fontWeight: FontWeight.w600),
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
                        'Propiedades',
                        community.propertyRegistry.count.toString(),
                        Icons.home_work_outlined,
                      ),
                      _buildStatCard('Usuarios', community.directory.members.length.toString(), Icons.people_outline),
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
                    color: AppColors.warning,
                    onPressed: onPendingPaymentsPressed
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    context,
                    title: 'Solicitudes de ingreso',
                    count: community.directory.pendingApplications.length,
                    icon: Icons.person_add_outlined,
                    color: AppColors.info,
                    onPressed: onPendingApplicationsPressed
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.grey600, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.grey900),
              ),
              Text(
                label,
                style: GoogleFonts.raleway(fontSize: 12, color: AppColors.grey500, fontWeight: FontWeight.w600),
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
    required VoidCallback onPressed
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
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
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold, color: AppColors.grey700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: count > 0 ? color : color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey600,),
          ],
        ),
      ),
    );
  }
}
