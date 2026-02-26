import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/payments/payment_card.dart';
import 'package:resipal_admin/shared/app_colors.dart';
import 'package:resipal_admin/shared/dynamic_selector.dart';
import 'package:resipal_core/presentation/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/views/loading_view.dart';
import 'payment_list_cubit.dart';
import 'payment_list_state.dart';

class PaymentListView extends StatelessWidget {
  const PaymentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentListCubit()..initialize(),
      child: BlocBuilder<PaymentListCubit, PaymentListState>(
        builder: (context, state) {
          if (state is LoadingState) return const LoadingView();
          if (state is ErrorState) return ErrorView();
          if (state is EmptyState) return const _EmptyPayments();

          if (state is LoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DynamicSelector(
                      options: state.selectorItems,
                      selectedValue: state.selector,
                      onSelected: (newSelector) => context.read<PaymentListCubit>().onSelectorChanged(newSelector),
                    ),
                    SizedBox(height: 16.0,),
                    ListView.separated(
                      
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.payments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => PaymentCard(state.payments[index]),
                    ),
                    SizedBox(height: 96.0,),
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
}

class _EmptyPayments extends StatelessWidget {
  const _EmptyPayments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: AppColors.secondary),
            const SizedBox(height: 16),
            Text('No hay historial de pagos registrados.', style: GoogleFonts.raleway(color: AppColors.secondary)),
          ],
        ),
      ),
    );
  }
}
