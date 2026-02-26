import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_cubit.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_state.dart';
import 'package:resipal_admin/shared/buttons/primary_cta_button.dart';
import 'package:resipal_admin/shared/loading/loading_bar.dart';
import 'package:resipal_core/domain/entities/payment/payment_entity.dart';
import 'package:resipal_core/domain/enums/payment_status.dart';
import 'package:resipal_core/presentation/shared/views/error_view.dart';
import 'package:resipal_core/presentation/shared/views/unknown_state_view.dart';

class ConfirmPaymentButton extends StatelessWidget {
  final PaymentEntity payment;
  const ConfirmPaymentButton(this.payment, {super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap with BlocProvider so children can "find" it
    return BlocProvider(
      create: (context) => ConfirmPaymentCubit()..initialize(payment.id),
      child: BlocBuilder<ConfirmPaymentCubit, ConfirmPaymentState>(
        builder: (ctx, state) {
          if (state is InitialState || state is LoadingState) {
            return const LoadingBar();
          }

          if (state is SubmittingState) {
            return PrimaryCtaButton(
                label: 'Confirmar pago recibido',
                canSubmit: false,
                isLoading: true,
              );
          }

          if (state is SubmittedSuccessfullyState) {
            return PrimaryCtaButton(label: '¡Confirmado!', canSubmit: false, onPressed: () {});
          }

          if (state is LoadedState) {
            if (state.payment.status == PaymentStatus.pendingReview) {
              return PrimaryCtaButton(
                label: 'Confirmar pago recibido',
                canSubmit: true,
                // Use 'ctx' (the one from BlocBuilder) to find the cubit
                onPressed: () => ctx.read<ConfirmPaymentCubit>().submit(payment),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          if (state is ErrorState) return ErrorView();

          return const UnknownStateView();
        },
      ),
    );
  }
}
