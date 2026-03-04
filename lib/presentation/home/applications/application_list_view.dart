import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/home/applications/application_card.dart';
import 'package:resipal_admin/presentation/home/applications/register_application/register_application_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/ui/texts/header_text.dart';

class ApplicationListView extends StatelessWidget {
  final List<ApplicationEntity> applications;

  const ApplicationListView(this.applications, {super.key});

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) return const _Empty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 96),
        itemCount: applications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => ApplicationCard(applications[index]),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.document_scanner_outlined, size: 64, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin solicitudes', textAlign: TextAlign.center, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No hay solicitudes pendientes ni invitaciones activas en este momento.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.inverseSurface),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => Go.to(RegisterApplicationPage()),
              icon: const Icon(Icons.add),
              label: const Text('Registrar solicitud'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
