import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/applications/application_card.dart';
import 'package:resipal_admin/presentation/applications/application_list/application_list_cubit.dart';
import 'package:resipal_admin/presentation/applications/application_list/application_list_state.dart';
import 'package:wester_kit/lib.dart';

class ApplicationListView extends StatelessWidget {
  const ApplicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ApplicationListCubit()..initialize(),
      child: BlocBuilder<ApplicationListCubit, ApplicationListState>(
        builder: (context, state) {
          return StateSwitcher(child: _buildStateWidget(context, state));
        },
      ),
    );
  }

  Widget _buildStateWidget(BuildContext context, ApplicationListState state) {
    if (state is LoadingState) {
      return const LoadingBar(key: ValueKey('loading'), title: 'Cargando solicitudes...');
    }

    if (state is EmptyState || (state is LoadedState && state.applications.isEmpty)) {
      return _buildEmptyState(context);
    }

    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }

    if (state is LoadedState) {
      return Padding(
        key: const ValueKey('loaded'),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.applications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) => ApplicationCard(application: state.applications[index]),
              ),
              const SizedBox(height: 96.0),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.secondary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.person_add_disabled_outlined, size: 64, color: colorScheme.secondary),
            ),
            const SizedBox(height: 24),
            HeaderText.five('No hay solicitudes', color: colorScheme.onBackground),
            const SizedBox(height: 8),
            Text(
              'Todas las solicitudes de ingreso han sido procesadas o no hay nuevos registros.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
