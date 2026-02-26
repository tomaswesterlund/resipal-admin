import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/contracts/contract_list/contract_list_page.dart';
import 'package:resipal_admin/presentation/home/admin_applications_view.dart';
import 'package:resipal_admin/presentation/home/overview/home_overview.dart';
import 'package:resipal_admin/presentation/memberships/membership_list/membership_list_view.dart';
import 'package:resipal_admin/presentation/payments/payment_list/payment_list_view.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_page.dart';
import 'package:resipal_admin/presentation/properties/property_list/property_list_view.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_page.dart';
import 'package:resipal_admin/shared/app_colors.dart';
import 'package:resipal_admin/shared/floating_nav_bar.dart';
import 'package:resipal_core/domain/entities/community/community_entity.dart';
import 'package:resipal_core/domain/entities/user_entity.dart';
import 'package:resipal_core/presentation/shared/my_app_bar.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/texts/section_header_text.dart';
import 'package:short_navigation/short_navigation.dart';

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
    return Scaffold(
      appBar: MyAppBar(title: _getAppBarTitle(), actions: _getAppBarActions()),
      extendBody: true,
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          HomeOverview(),
          PropertyListView(),
          PaymentListView(),
          AdminApplicationsView(widget.community.directory.pendingApplications),
          MembershipListView(),
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
          FloatingNavBarItem(icon: Icons.dashboard_outlined, label: 'Início'),
          FloatingNavBarItem(icon: Icons.apartment_rounded, label: 'Propiedades'),
          FloatingNavBarItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Pagos',
            // Using warning (Yellow) for pending payments
            warningBadgeCount: widget.community.paymentLedger.pendingPayments.length,
          ),
          FloatingNavBarItem(
            icon: Icons.person_add_alt_1_outlined,
            label: 'Solicitudes',
            // Using info (Blue) or warning for applications
            badgeCount: widget.community.directory.pendingApplications.length,
          ),
          FloatingNavBarItem(icon: Icons.groups_outlined, label: 'Miembros'),
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
            // 1. Brand/Community Header
            _buildDrawerHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeaderText(text: 'CONFIGURACIÓN'),
                    const SizedBox(height: 16),

                    _buildDrawerItem(icon: Icons.settings_applications_outlined, label: 'Comunidad', onTap: () {}),
                    _buildDrawerItem(
                      icon: Icons.description_outlined,
                      label: 'Contratos',
                      onTap: () => Go.to(ContractListPage()),
                    ),
                    _buildDrawerItem(icon: Icons.apartment_outlined, label: 'Propiedades', onTap: () {}),
                    _buildDrawerItem(icon: Icons.manage_accounts_outlined, label: 'Usuarios', onTap: () {}),

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

            // 3. Footer versioning/info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Resipal Admin v1.0.4',
                style: GoogleFonts.raleway(fontSize: 10, color: AppColors.auxiliarScale[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    const titles = ['Resipal - Administrator', 'Propiedades', 'Pagos', 'Solicitudes', 'Miembros'];
    return titles[_currentPageIndex];
  }

  List<Widget> _getAppBarActions() {
    return [];
    switch (_currentPageIndex) {
      case 0: // Overview
        return [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () => print("Notifications tapped"))];
      case 1: // Properties
        return [IconButton(icon: const Icon(Icons.add_business), onPressed: () => print("Add property tapped"))];
      case 2: // Payments
        return [
          IconButton(icon: const Icon(Icons.file_download), onPressed: () => print("Export ledger tapped")),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () => print("Filter payments tapped")),
        ];
      case 3: // Applications
        return [IconButton(icon: const Icon(Icons.playlist_add_check), onPressed: () => print("Bulk approve tapped"))];
      case 4: // Members
        return [IconButton(icon: const Icon(Icons.person_add), onPressed: () => print("Invite member tapped"))];
      default:
        return [];
    }
  }

  Widget? _getFAB() {
    switch (_currentPageIndex) {
      case 1: // Properties
        return FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Go.to(RegisterPropertyPage()),
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 2: // Payments
        return FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Go.to(RegisterPaymentPage()),
          child: const Icon(Icons.add, color: Colors.white),
        );
      // case 2: // Payments
      //   return FloatingActionButton(
      //     backgroundColor: BaseAppColors.secondaryScale[500],
      //     onPressed: () => Go.to(RegisterPaymentPage()),
      //     child: const Icon(Icons.add, color: Colors.white),
      //   );
      // case 4: // Members
      //   return FloatingActionButton(
      //     backgroundColor: BaseAppColors.secondary,
      //     onPressed: () => _inviteMember(),
      //     child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      //   );
      default:
        return null; // No FAB for Overview or Applications
    }
  }

  Widget _buildDrawerHeader() {
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
          HeaderText.five(widget.community.name, color: Colors.white),
          Text(widget.user.email, style: GoogleFonts.raleway(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String label, required VoidCallback onTap, Color? color}) {
    final itemColor = color ?? AppColors.auxiliarScale[700]!;

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
