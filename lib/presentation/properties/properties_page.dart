import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/properties/property_list_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/ui/my_app_bar.dart';

class PropertiesPage extends StatelessWidget {
  final List<PropertyEntity> properties;
  const PropertiesPage(this.properties, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Pagos'),
      body: PropertyListView(properties)
    );
  }
}