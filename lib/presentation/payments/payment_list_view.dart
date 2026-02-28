import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/payments/payment_card.dart';
import 'package:resipal_core/lib.dart';
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
    final filteredPayments = _selectedFilter.value == null
        ? widget.payments
        : widget.payments.where((p) => p.status == _selectedFilter.value).toList();

        filteredPayments.sort((a, b) => b.date.compareTo(a.date));

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

            // 3. Conditional empty state if filter returns nothing
            if (filteredPayments.isEmpty)
              _buildEmptyFilterState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPayments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) => PaymentCard(filteredPayments[index]),
              ),

            const SizedBox(height: 96.0),
          ],
        ),
      ),
    );
  }

  List<FilterSelectorItem> _getFilterOptions() {
    return [
      FilterSelectorItem(label: 'Todos', value: null),
      FilterSelectorItem(label: 'Pendientes', value: PaymentStatus.pendingReview),
      FilterSelectorItem(label: 'Aprobados', value: PaymentStatus.approved),
    ];
  }

  Widget _buildEmptyFilterState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Icon(Icons.search_off_outlined, color: Colors.grey.withOpacity(0.5), size: 48),
          const SizedBox(height: 12),
          const Text(
            'No hay pagos con este filtro',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// class PaymentListView extends StatelessWidget {
//   const PaymentListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PaymentListCubit()..initialize(),
//       child: BlocBuilder<PaymentListCubit, PaymentListState>(
//         builder: (context, state) {
//           if (state is LoadingState) return const LoadingView();
//           if (state is ErrorState) return ErrorView();
//           if (state is EmptyState) return const _EmptyPayments();

//           if (state is LoadedState) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     FilterSelector(
//                       options: state.filterItems,
//                       selectedValue: state.selectedFilter,
//                       onSelected: (newSelector) => context.read<PaymentListCubit>().onFilterChanged(newSelector),
//                     ),
//                     SizedBox(height: 16.0,),
//                     ListView.separated(

//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: state.payments.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 8),
//                       itemBuilder: (context, index) => PaymentCard(state.payments[index]),
//                     ),
//                     SizedBox(height: 96.0,),
//                   ],
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

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
