import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/contracts/contract_list/contract_list_page.dart';
import 'package:resipal_admin/presentation/home/applications/application_list_view.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview.dart';
import 'package:resipal_admin/presentation/members/member_list_view.dart';
import 'package:resipal_admin/presentation/payments/payment_list_view.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_page.dart';
import 'package:resipal_admin/presentation/properties/properties_page.dart';
import 'package:resipal_admin/presentation/properties/property_list_view.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_page.dart';
import 'package:resipal_admin/presentation/users/register_user/register_user_page.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

import 'admin_home_cubit.dart';
import 'admin_home_state.dart';

enum AdminHomePages { home, properties, payments, applications, members }

class AdminHomePage extends StatefulWidget {
  final CommunityEntity community;
  final UserEntity user;

  const AdminHomePage({required this.community, required this.user, super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentPageIndex = AdminHomePages.home.index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => AdminHomeCubit()..initialize(widget.community),
      child: BlocBuilder<AdminHomeCubit, AdminHomeState>(
        builder: (context, state) {
          final community = (state is LoadedState) ? state.community : widget.community;

          return Scaffold(
            appBar: MyAppBar(title: _getAppBarTitle(), actions: _getAppBarActions()),
            extendBody: true,
            backgroundColor: colorScheme.background,
            body: IndexedStack(
              index: _currentPageIndex,
              children: [
                HomeOverview(
                  onPendingApplicationsPressed: () =>
                      setState(() => _currentPageIndex = AdminHomePages.applications.index),
                  onPendingPaymentsPressed: () => setState(() => _currentPageIndex = AdminHomePages.payments.index),
                ),
                PropertyListView(community.propertyRegistry.properties),
                PaymentListView(community.paymentLedger.payments),
                ApplicationListView(community.applications),
                MemberListView(community.memberDirectory.members),
              ],
            ),
            bottomNavigationBar: FloatingNavBar(
              currentIndex: _currentPageIndex,
              onChanged: (index) => setState(() => _currentPageIndex = index),
              items: [
                FloatingNavBarItem(icon: Icons.dashboard_outlined, label: 'Inicio'),
                FloatingNavBarItem(icon: Icons.house_outlined, label: 'Propiedades'),
                FloatingNavBarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Pagos',
                  badgeCount: community.paymentLedger.pendingPayments.length,
                ),
                FloatingNavBarItem(
                  icon: Icons.document_scanner,
                  label: 'Solicitudes',
                  warningBadgeCount: community.applications.length,
                ),
                FloatingNavBarItem(icon: Icons.groups_outlined, label: 'Miembros'),
              ],
            ),
            floatingActionButton: _getFAB(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            drawer: Drawer(
              backgroundColor: colorScheme.background,
              width: MediaQuery.of(context).size.width * 0.85,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildDrawerHeader(context, community),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeaderText(text: 'CONFIGURACIÓN'),
                          const SizedBox(height: 16),
                          _buildDrawerItem(
                            context,
                            icon: Icons.settings_applications_outlined,
                            label: 'Comunidad',
                            onTap: () {},
                          ),
                          _buildDrawerItem(
                            context,
                            icon: Icons.description_outlined,
                            label: 'Contratos',
                            onTap: () => Go.to(const ContractListPage()),
                          ),
                          _buildDrawerItem(
                            context,
                            icon: Icons.manage_accounts_outlined,
                            label: 'Miembros',
                            onTap: () {}, //() => Go.to(UsersPage(community.userDirectory.users)),
                          ),

                          _buildDrawerItem(
                            context,
                            icon: Icons.apartment_outlined,
                            label: 'Propiedades',
                            onTap: () => Go.to(PropertiesPage(community.propertyRegistry.properties)),
                          ),

                          _buildDrawerItem(context, icon: Icons.bar_chart_outlined, label: 'Reportes', onTap: () {}),
                          _buildDrawerItem(
                            context,
                            icon: Icons.document_scanner,
                            label: 'Solicitudes',
                            onTap: () {}, //() => Go.to(UsersPage(community.userDirectory.users)),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Divider(thickness: 1)),
                          const SectionHeaderText(text: 'SISTEMA'),
                          const SizedBox(height: 16),
                          _buildDrawerItem(
                            context,
                            icon: Icons.logout_rounded,
                            label: 'Cerrar Sesión',
                            color: colorScheme.error,
                            onTap: () {},
                          ),
                          const SizedBox(height: 12.0),
                          Center(
                            child: Text(
                              'Resipal Admin v1.0.4',
                              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                            ),
                          ),
                        ],
                      ),
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
    const titles = ['Resipal - Administrator', 'Propiedades', 'Pagos', 'Solicitudes', 'Miembros'];
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
        return [IconButton(icon: const Icon(Icons.add), onPressed: () => Go.to(RegisterUserPage()))];
      default:
        return [];
    }
  }

  Widget? _getFAB() {
    if (_currentPageIndex == 1) {
      return WkFloatingActionButton(onPressed: () => Go.to(const RegisterPropertyPage()));
    }
    if (_currentPageIndex == 2) {
      return WkFloatingActionButton(onPressed: () => Go.to(const RegisterPaymentPage()));
    }
    return null;
  }

  Widget _buildDrawerHeader(BuildContext context, CommunityEntity community) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, bottom: 32, right: 24),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
            child: Icon(Icons.business, color: colorScheme.onPrimary, size: 35),
          ),
          const SizedBox(height: 16),
          HeaderText.five(community.name, color: colorScheme.onPrimary),
          const SizedBox(height: 4),
          Text(
            widget.user.email,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primaryColor = color ?? colorScheme.primary;
    final itemTextColor = color ?? colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: itemTextColor),
        ),
        tileColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}
