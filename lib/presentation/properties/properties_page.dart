import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/payments/payment_list_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/ui/my_app_bar.dart';

class PropertiesPage extends StatelessWidget {
  final List<PaymentEntity> payments;
  const PropertiesPage(this.payments, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Pagos'),
      body: PaymentListView(payments)
    );
  }
}