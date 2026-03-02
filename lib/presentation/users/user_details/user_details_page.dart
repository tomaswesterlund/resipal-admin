import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/payments/payment_list_view.dart';
import 'package:resipal_admin/presentation/properties/property_list_view.dart';
import 'package:resipal_admin/presentation/users/user_information_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class UserDetailsPage extends StatefulWidget {
  final MembershipEntity membership;
  const UserDetailsPage(this.membership, {super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Detalle de Usuario'),
      body: _getBody(_currentIndex),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          FloatingNavBarItem(icon: Icons.person_2_outlined, label: 'Información'),
          FloatingNavBarItem(icon: Icons.house_outlined, label: 'Propiedades'),
          FloatingNavBarItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Pagos',
            badgeCount: widget.membership.resident.paymentLedger.pendingPayments.length,
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    if(index == 0) return UserInformationView(membership: widget.membership);
    if (index == 1) return PropertyListView(widget.membership.resident.propertyRegistery.properties);
    if (index == 2) return PaymentListView(widget.membership.resident.paymentLedger.payments);

    return Text('Unimplemented');
  }
}
