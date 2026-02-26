import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_button.dart';
import 'package:resipal_admin/presentation/payments/payment_header.dart';
import 'payment_details_cubit.dart';
import 'payment_details_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String paymentId;
  const PaymentDetailsPage({required this.paymentId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MyAppBar(title: 'Detalle de Pago'),
      body: BlocProvider(
        create: (ctx) => PaymentDetailsCubit()..initialize(paymentId),
        child: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
          builder: (ctx, state) {
            if (state is InitialState || state is LoadingState) {
              return LoadingView();
            }

            if (state is LoadedState) {
              return _Loaded(payment: state.payment);
            }

            if (state is ErrorState) {
              return ErrorView();
            }

            return UnknownStateView();
          },
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  final PaymentEntity payment;
  const _Loaded({required this.payment, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentHeader(payment),

          if (payment.status == PaymentStatus.pendingReview) ...[
            const SizedBox(height: 12),
            ConfirmPaymentButton(payment)
          ],

          const SizedBox(height: 32),

          if (payment.receiptPath != null && payment.receiptPath!.isNotEmpty) ...[
            SectionHeaderText(text: 'COMPROBANTE ADJUNTO'),
            ImagePreview(imageUrl: payment.receiptPath!,),
            const SizedBox(height: 20),
          ],

          SectionHeaderText(text: 'INFORMACIÓN GENERAL'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.event_available_rounded,
                  label: 'Fecha de pago',
                  value: payment.date.toShortDate(),
                ),
                const Divider(height: 1),
                DetailTile(
                  icon: Icons.upload_file_rounded,
                  label: 'Fecha de registro (en Resipal)',
                  value: payment.createdAt.toShortDate(),
                ),
                const Divider(height: 1),
                DetailTile(
                  icon: Icons.tag,
                  label: 'Referencia',
                  value: payment.reference?.isNotEmpty == true ? payment.reference! : 'Sin referencia',
                ),
                const Divider(height: 1),
                DetailTile(
                  icon: Icons.info_outline,
                  label: 'ID de registro',
                  value: '#${payment.id.split('-').first.toUpperCase()}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notes Section
          if (payment.note != null && payment.note!.isNotEmpty) ...[
            const SectionHeaderText(text: 'NOTA / CONCEPTO'),
            DefaultCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(payment.note!, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
