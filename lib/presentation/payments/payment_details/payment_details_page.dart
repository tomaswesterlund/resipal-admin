import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/shared/bucket_image/bucket_image.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_button.dart';
import 'package:resipal_admin/presentation/payments/payment_header.dart';
import 'package:shimmer/shimmer.dart';
import 'payment_details_cubit.dart';
import 'payment_details_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String paymentId;
  const PaymentDetailsPage({required this.paymentId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PaymentDetailsCubit()..initialize(paymentId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const MyAppBar(title: 'Detalle de Pago'),
        body: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
          builder: (ctx, state) {
            // StateSwitcher handles the cross-fade animation between the widgets
            return StateSwitcher(child: _buildStateWidget(state));
          },
        ),
      ),
    );
  }

  Widget _buildStateWidget(PaymentDetailsState state) {
    if (state is InitialState || state is LoadingState) {
      return const _PaymentDetailsShimmer();
    }

    if (state is LoadedState) {
      return _Loaded(state.payment, key: const ValueKey('loaded'));
    }

    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }

    return const UnknownStateView(key: ValueKey('unknown'));
  }
}

class _Loaded extends StatelessWidget {
  final PaymentEntity payment;

  const _Loaded(this.payment, {super.key});

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
            ConfirmPaymentButton(payment),
          ],

          const SizedBox(height: 32),

          if (payment.receiptPath != null) ...[
            const SectionHeaderText(text: 'COMPROBANTE ADJUNTO'),
            BucketImage(bucket: 'payments', path: payment.receiptPath!),
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

class _PaymentDetailsShimmer extends StatelessWidget {
  const _PaymentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Shimmer
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 32),

            // Image Placeholder Shimmer
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 32),

            // Detail Card Shimmer
            Container(
              height: 240,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
