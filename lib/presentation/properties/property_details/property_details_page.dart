import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'property_details_cubit.dart';
import 'property_details_state.dart';

class PropertyDetailsPage extends StatelessWidget {
  final String propertyId;
  const PropertyDetailsPage({required this.propertyId, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => PropertyDetailsCubit(propertyId: propertyId)..initialize(),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Detalle de Propiedad'),
        body: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
          builder: (context, state) {
            if (state is LoadingState) return const LoadingView();
            if (state is ErrorState) return const ErrorView();
            if (state is LoadedState) return _PropertyContent(state.property);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _PropertyContent extends StatelessWidget {
  final PropertyEntity property;
  const _PropertyContent(this.property);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context),
                const SizedBox(height: 24),
                HeaderText.five('Historial de Cuotas', color: colorScheme.primary),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _FeeTile(property.fees[index]),
              childCount: property.fees.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText.four(property.name, color: colorScheme.primary),
          Text(
            property.resident?.name ?? 'Sin residente',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline, 
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(height: 32, color: colorScheme.outlineVariant),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn(context, 'Contrato', property.contract?.name ?? 'N/A'),
              _infoColumn(context, 'Deuda Total', '', amount: property.totalOverdueFeeInCents),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(BuildContext context, String label, String value, {int? amount}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold, 
            color: colorScheme.outline,
            letterSpacing: 0.5,
          ),
        ),
        if (amount != null)
          AmountText.fromCents(
            amount, 
            fontSize: 16, 
            color: amount > 0 ? colorScheme.error : colorScheme.onSurface,
          )
        else
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600, 
              color: colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

class _FeeTile extends StatelessWidget {
  final MaintenanceFeeEntity fee;
  const _FeeTile(this.fee);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Cuota de ${fee.dueDate.toShortDate()}', // Assumes a date formatting helper
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          fee.status.name.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: _getStatusColor(context, fee.status), 
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: AmountText.fromCents(fee.amountInCents, fontSize: 16),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, dynamic status) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusStr = status.toString().toLowerCase();

    if (statusStr.contains('paid')) return Colors.green.shade600;
    if (statusStr.contains('overdue')) return colorScheme.error;
    return Colors.orange; // Default for pending/processing
  }
}