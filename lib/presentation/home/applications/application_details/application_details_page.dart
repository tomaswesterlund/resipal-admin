import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/home/applications/application_header.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'application_details_cubit.dart';
import 'application_details_state.dart';

class ApplicationDetailsPage extends StatelessWidget {
  final ApplicationEntity application;
  const ApplicationDetailsPage({required this.application, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (ctx) => ApplicationDetailsCubit()..initialize(application),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Detalle de Solicitud'),
        body: BlocBuilder<ApplicationDetailsCubit, ApplicationDetailsState>(
          builder: (ctx, state) {
            return StateSwitcher(child: _buildStateWidget(state));
          },
        ),
      ),
    );
  }

  Widget _buildStateWidget(ApplicationDetailsState state) {
    if (state is InitialState || state is LoadingState) {
      return const _ApplicationDetailsShimmer();
    }

    if (state is LoadedState) {
      return _Loaded(state.application, key: const ValueKey('loaded'));
    }

    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }

    return const UnknownStateView(key: ValueKey('unknown'));
  }
}

class _Loaded extends StatelessWidget {
  final ApplicationEntity application;

  const _Loaded(this.application, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ApplicationHeader(application),

          // Action Buttons (if pending)
          if (application.status == ApplicationStatus.pendingApproval) ...[
            const SizedBox(height: 12),
            // Replace with your actual action buttons/logic
            PrimaryButton(label: 'Revisar Solicitud', onPressed: () => {}),
          ],

          const SizedBox(height: 32),

          const SectionHeaderText(text: 'INFORMACIÓN DE CONTACTO'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Nombre completo',
                  value: application.name,
                  enableCopy: true,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.phone_android_rounded,
                  label: 'Teléfono',
                  value: application.phoneNumber,
                  enableCopy: true,
                ),
                if (application.emergencyPhoneNumber != null) ...[
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  DetailTile(
                    icon: Icons.contact_emergency_outlined,
                    label: 'Teléfono de emergencia',
                    value: application.emergencyPhoneNumber!,
                    enableCopy: true,
                  ),
                ],
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.alternate_email_rounded,
                  label: 'Correo electrónico',
                  value: application.email,
                  enableCopy: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const SectionHeaderText(text: 'DETALLES DE LA SOLICITUD'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Fecha de creación',
                  value: application.createdAt.toShortDate(),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(icon: Icons.assignment_ind_outlined, label: 'Roles solicitados', value: _getRolesString()),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.info_outline,
                  label: 'ID de solicitud',
                  value: '#${application.id.split('-').first.toUpperCase()}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Message Section
          if (application.message.isNotEmpty) ...[
            const SectionHeaderText(text: 'MENSAJE / MOTIVACIÓN'),
            DefaultCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  application.message,
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  String _getRolesString() {
    List<String> roles = [];
    if (application.isAdmin) roles.add('Admin');
    if (application.isResident) roles.add('Residente');
    if (application.isSecurity) roles.add('Seguridad');
    return roles.isEmpty ? 'Ninguno' : roles.join(', ');
  }
}

class _ApplicationDetailsShimmer extends StatelessWidget {
  const _ApplicationDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceVariant.withOpacity(0.4),
      highlightColor: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 32),
            Container(
              height: 220,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 32),
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
