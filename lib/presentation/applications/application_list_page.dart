import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/applications/application_list_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/ui/my_app_bar.dart';

class ApplicationListPage extends StatelessWidget {
  final List<ApplicationEntity> applications;
  const ApplicationListPage({required this.applications, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Solicitudes'),
      body: ApplicationListView(applications),
    );
  }
}
