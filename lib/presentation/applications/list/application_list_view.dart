import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/applications/application_card.dart';
import 'package:resipal_admin/presentation/applications/list/application_list_cubit.dart';
import 'package:resipal_admin/presentation/applications/list/application_list_state.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:wester_kit/lib.dart';

class ApplicationListView extends StatelessWidget {
  const ApplicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ApplicationListCubit()..initialize(),
      child: BlocBuilder<ApplicationListCubit, ApplicationListState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmptyState || (state is LoadedState && state.applications.isEmpty)) {
            return _buildEmptyState();
          }

          if (state is ErrorState) {
            return const Center(child: Text('Error al cargar las solicitudes'));
          }

          if (state is LoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.applications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => ApplicationCard(application: state.applications[index]),
                    ),
                    SizedBox(height: 96.0),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_disabled_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          HeaderText.five('No hay solicitudes', color: AppColors.grey700),
          const SizedBox(height: 8),
          const Text('Todas las solicitudes han sido procesadas.'),
        ],
      ),
    );
  }
}
