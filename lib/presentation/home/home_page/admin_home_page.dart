import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/applications/list/application_list_view.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/contracts/contract_list/contract_list_page.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview.dart';
import 'package:resipal_admin/presentation/users/user_list/user_list_view.dart';
import 'package:resipal_admin/presentation/payments/payment_list/payment_list_view.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_page.dart';
import 'package:resipal_admin/presentation/properties/property_list/property_list_view.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_page.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

import 'admin_home_cubit.dart';
import 'admin_home_state.dart';

class AdminHomePage extends StatefulWidget {
  final CommunityEntity community;
  final UserEntity user;

  const AdminHomePage({required this.community, required this.user, super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminHomeCubit()..initialize(widget.community),
      child: BlocBuilder<AdminHomeCubit, AdminHomeState>(
        builder: (context, state) {
          // Fallback to widget data if stream hasn't emitted yet
          final community = (state is LoadedState) ? state.community : widget.community;

          return Scaffold(
            appBar: MyAppBar(title: _getAppBarTitle(), actions: _getAppBarActions()),
            extendBody: true,
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: _currentPageIndex,
              children: [
                const HomeOverview(),
                const PropertyListView(),
                const PaymentListView(),
                const ApplicationListView(),
                const UserListView(),
              ],
            ),
            bottomNavigationBar: FloatingNavBar(
              currentIndex: _currentPageIndex,
              onChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              items: [
                FloatingNavBarItem(icon: Icons.dashboard_outlined, label: 'Inicio'),
                FloatingNavBarItem(icon: Icons.apartment_rounded, label: 'Propiedades'),
                FloatingNavBarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Pagos',
                  badgeCount: community.paymentLedger.pendingPayments.length,
                ),
                FloatingNavBarItem(
                  icon: Icons.person_add_alt_1_outlined,
                  label: 'Solicitudes',
                  badgeCount: community.directory.pendingApplications.length,
                ),
                FloatingNavBarItem(icon: Icons.groups_outlined, label: 'Usuarios'),
              ],
            ),
            floatingActionButton: _getFAB(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            drawer: Drawer(
              backgroundColor: AppColors.background,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildDrawerHeader(community),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeaderText(text: 'CONFIGURACIÓN'),
                          const SizedBox(height: 16),
                          _buildDrawerItem(
                            icon: Icons.settings_applications_outlined,
                            label: 'Comunidad',
                            onTap: () {},
                          ),
                          _buildDrawerItem(
                            icon: Icons.description_outlined,
                            label: 'Contratos',
                            onTap: () => Go.to(const ContractListPage()),
                          ),
                          _buildDrawerItem(icon: Icons.apartment_outlined, label: 'Propiedades', onTap: () {}),
                          _buildDrawerItem(icon: Icons.manage_accounts_outlined, label: 'Usuarios', onTap: () {}),
                          // Added Reports Item here
                          _buildDrawerItem(icon: Icons.bar_chart_outlined, label: 'Reportes', onTap: () {}),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider()),
                          const SectionHeaderText(text: 'SISTEMA'),
                          const SizedBox(height: 16),
                          _buildDrawerItem(
                            icon: Icons.logout_rounded,
                            label: 'Cerrar Sesión',
                            color: AppColors.danger,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Resipal Admin v1.0.4',
                      style: GoogleFonts.raleway(fontSize: 10, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAppBarTitle() {
    const titles = ['Resipal - Administrator', 'Propiedades', 'Pagos', 'Solicitudes', 'Usuarios'];
    return titles[_currentPageIndex];
  }

  List<Widget> _getAppBarActions() {
    switch (_currentPageIndex) {
      case 0:
        return [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})];
      case 1:
        return [IconButton(icon: const Icon(Icons.add_business), onPressed: () {})];
      case 2:
        return [
          IconButton(icon: const Icon(Icons.file_download), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ];
      case 3:
        return [IconButton(icon: const Icon(Icons.playlist_add_check), onPressed: () {})];
      case 4:
        return [IconButton(icon: const Icon(Icons.person_add), onPressed: () {})];
      default:
        return [];
    }
  }

  Widget? _getFAB() {
    switch (_currentPageIndex) {
      case 1:
        return FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Go.to(const RegisterPropertyPage()),
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Go.to(const RegisterPaymentPage()),
          child: const Icon(Icons.add, color: Colors.white),
        );
      default:
        return null;
    }
  }

  Widget _buildDrawerHeader(CommunityEntity community) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.business, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 16),
          HeaderText.five(community.name, color: Colors.white),
          Text(widget.user.email, style: GoogleFonts.raleway(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    final itemColor = color ?? AppColors.grey700!;
    return ListTile(
      leading: Icon(icon, color: itemColor, size: 22),
      title: Text(
        label,
        style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600, color: itemColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
