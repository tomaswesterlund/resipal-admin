import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/payments/payment_card.dart';
import 'package:resipal_admin/presentation/payments/register_payment/register_payment_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:short_navigation/short_navigation.dart';
import 'package:wester_kit/lib.dart';

class PaymentListView extends StatefulWidget {
  final List<PaymentEntity> payments;

  const PaymentListView(this.payments, {super.key});

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  late FilterSelectorItem<PaymentStatus?> _selectedFilter;
  late List<FilterSelectorItem<PaymentStatus?>> _filterOptions;

  @override
  void initState() {
    super.initState();
    _filterOptions = [
      const FilterSelectorItem(label: 'Todos', value: null),
      const FilterSelectorItem(label: 'Pendientes', value: PaymentStatus.pendingReview),
      const FilterSelectorItem(label: 'Aprobados', value: PaymentStatus.approved),
    ];
    _selectedFilter = _filterOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 1. Filter Logic
    final filteredPayments = _selectedFilter.value == null
        ? widget.payments
        : widget.payments.where((p) => p.status == _selectedFilter.value).toList();

    // 2. Sort by date (Descending)
    filteredPayments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (widget.payments.isEmpty) return const _Empty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterSelector<PaymentStatus?>(
              options: _filterOptions,
              selectedValue: _selectedFilter,
              onSelected: (newItem) {
                setState(() {
                  _selectedFilter = newItem;
                });
              },
            ),

            const SizedBox(height: 16.0),

            if (filteredPayments.isEmpty)
              _buildEmptyFilterState(context)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPayments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) => PaymentCard(filteredPayments[index]),
              ),

            const SizedBox(height: 96.0),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Icon(Icons.search_off_outlined, color: colorScheme.outline.withOpacity(0.5), size: 48),
          const SizedBox(height: 12),
          Text(
            'No hay pagos con este filtro',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.attach_money, size: 64, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin pagos', textAlign: TextAlign.center, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Aún no has registrado ningún pago en esta sección.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.inverseSurface),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => Go.to(const RegisterPaymentPage()),
              icon: const Icon(Icons.add),
              label: const Text('Registrar pago'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
