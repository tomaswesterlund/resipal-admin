import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_core/domain/entities/property_entity.dart';
import 'package:resipal_core/domain/entities/maintenance_fee_entity.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/my_app_bar.dart';
import 'package:resipal_core/presentation/shared/texts/amount_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';
import 'package:resipal_core/presentation/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/views/loading_view.dart';
import 'property_details_cubit.dart';
import 'property_details_state.dart';

class PropertyDetailsPage extends StatelessWidget {
  final String propertyId;
  const PropertyDetailsPage({required this.propertyId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyDetailsCubit(propertyId: propertyId)..initialize(),
      child: Scaffold(
        backgroundColor: BaseAppColors.background,
        appBar: const MyAppBar(title: 'Detalle de Propiedad'),
        body: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
          builder: (context, state) {
            if (state is LoadingState) return const LoadingView();
            if (state is ErrorState) return ErrorView();
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
                HeaderText.five('Historial de Cuotas', color: const Color(0xFF1A4644)),
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

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText.four(property.name, color: const Color(0xFF1A4644)),
          Text(
            property.resident?.name ?? 'Sin residente',
            style: GoogleFonts.raleway(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Contrato', property.contract?.name ?? 'N/A'),
              _infoColumn('Deuda Total', '', amount: property.totalOverdueFeeInCents),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, {int? amount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        if (amount != null)
          AmountText.fromCents(amount, fontSize: 16, color: amount > 0 ? BaseAppColors.danger : BaseAppColors.secondary)
        else
          Text(
            value,
            style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text('Cuota de ${fee}', style: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
        subtitle: Text(
          fee.status.name.toUpperCase(),
          style: TextStyle(color: _getStatusColor(fee.status), fontSize: 11, fontWeight: FontWeight.bold),
        ),
        trailing: AmountText.fromCents(fee.amountInCents, fontSize: 16),
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    // Basic mapping example
    if (status.toString().contains('paid')) return BaseAppColors.secondary;
    if (status.toString().contains('overdue')) return BaseAppColors.danger;
    return Colors.orange;
  }
}
