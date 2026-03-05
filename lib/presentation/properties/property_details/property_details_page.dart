import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/home/maintenance/maintenance_fee_card.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'property_details_cubit.dart';
import 'property_details_state.dart';

class PropertyDetailsPage extends StatefulWidget {
  final PropertyEntity property;
  const PropertyDetailsPage({required this.property, super.key});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => PropertyDetailsCubit()..initialize(widget.property),
      child: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
        builder: (context, state) {
          final currentProperty = (state is LoadedState) ? state.property : widget.property;

          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: MyAppBar(title: currentProperty.name),
            body: _buildStateWidget(state),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 0.0, left: 0.0, right: 0.0),
              child: FloatingNavBar(
                currentIndex: _currentPageIndex,
                onChanged: (index) => setState(() => _currentPageIndex = index),
                items: [
                  FloatingNavBarItem(icon: Icons.info_outline_rounded, label: 'General'),
                  FloatingNavBarItem(
                    icon: Icons.history_rounded,
                    label: 'Mantenemiento',
                    showDanger: currentProperty.fees.where((f) => f.status == MaintenanceFeeStatus.overdue).isNotEmpty,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateWidget(PropertyDetailsState state) {
    if (state is LoadingState) return const LoadingView();
    if (state is ErrorState) return const ErrorView();
    if (state is LoadedState) {
      return _currentPageIndex == 0 ? _PropertyOverview(state.property) : _PropertyFeesHistory(state.property);
    }
    return const SizedBox.shrink();
  }
}

// --- VIEW 1: GENERAL INFORMATION ---
class _PropertyOverview extends StatelessWidget {
  final PropertyEntity property;
  const _PropertyOverview(this.property);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderText(text: 'DETALLES DE LA PROPIEDAD'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(icon: Icons.home_rounded, label: 'Nombre', value: property.name),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.person_rounded,
                  label: 'Residente',
                  value: property.resident?.name ?? 'Sin residente asignado',
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.description_outlined,
                  label: 'Descripción',
                  value: property.description ?? 'Sin descripción',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeaderText(text: 'CONTRATO Y FINANZAS'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.assignment_rounded,
                  label: 'Tipo de Contrato',
                  value: property.contract?.name ?? 'N/A',
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.warning_amber_rounded,
                  label: 'Deuda Acumulada',
                  value: CurrencyFormatter.fromCents(property.totalOverdueFeeInCents),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- VIEW 2: MAINTENANCE FEES HISTORY ---
class _PropertyFeesHistory extends StatelessWidget {
  final PropertyEntity property;
  const _PropertyFeesHistory(this.property);

  @override
  Widget build(BuildContext context) {
    final sortedFees = List<MaintenanceFeeEntity>.from(property.fees)
    ..sort((a, b) => b.fromDate.compareTo(a.fromDate));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: sortedFees.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => MaintenanceFeeCard(sortedFees[index]),
    );
  }
}
