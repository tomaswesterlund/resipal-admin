import 'package:flutter/material.dart';
import 'package:resipal_core/domain/entities/application_entity.dart';
import 'package:resipal_core/presentation/applications/application_card.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';

class AdminApplicationsView extends StatelessWidget {
  final List<ApplicationEntity> applications;
  
  const AdminApplicationsView(this.applications, {super.key});

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: BodyText.medium(
            'No se encontraron solicitudes registradas.',
            color: Colors.grey.shade600,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      itemCount: applications.length,
      itemBuilder: (ctx, index) {
        return ApplicationCard(applications[index]);
      },
    );
  }
}