import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/shared/bucket_image/bucket_image.dart';
import 'package:resipal_admin/presentation/payments/confirm_payment/confirm_payment_button.dart';
import 'package:resipal_admin/presentation/payments/payment_header.dart';
import 'package:shimmer/shimmer.dart';
import 'payment_details_cubit.dart';
import 'payment_details_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PaymentDetailsPage extends StatelessWidget {
  final PaymentEntity payment;
  const PaymentDetailsPage({required this.payment, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (ctx) => PaymentDetailsCubit()..initialize(payment),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Detalle de Pago'),
        body: BlocBuilder<PaymentDetailsCubit, PaymentDetailsState>(
          builder: (ctx, state) {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            // Note: BucketImage should also be updated to handle loading/error internally
            BucketImage(bucket: 'payments', path: payment.receiptPath!),
            const SizedBox(height: 20),
          ],

          const SectionHeaderText(text: 'INFORMACIÓN GENERAL'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.event_available_rounded,
                  label: 'Fecha de pago',
                  value: payment.date.toShortDate(),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.upload_file_rounded,
                  label: 'Fecha de registro',
                  value: payment.createdAt.toShortDate(),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.tag,
                  label: 'Referencia',
                  value: payment.reference?.isNotEmpty == true ? payment.reference! : 'Sin referencia',
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
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
                child: Text(
                  payment.note!, 
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
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
  const _PaymentDetailsShimmer();

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
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 32),
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