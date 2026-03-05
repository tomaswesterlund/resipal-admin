import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/payments/payment_list_view.dart';
import 'package:resipal_admin/presentation/properties/property_list_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'member_details_cubit.dart';
import 'member_details_state.dart';

class MemberDetailsPage extends StatefulWidget {
  final MemberEntity member;
  const MemberDetailsPage({required this.member, super.key});

  @override
  State<MemberDetailsPage> createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (ctx) => MemberDetailsCubit()..initialize(widget.member),
      child: BlocBuilder<MemberDetailsCubit, MemberDetailsState>(
        builder: (context, state) {
          // Get the live member data from state if loaded, otherwise use initial widget data
          final currentMember = (state is LoadedState) ? state.member : widget.member;

          return Scaffold(
            backgroundColor: colorScheme.background,
            appBar: MyAppBar(title: currentMember.name),
            body: _buildStateWidget(state),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 0.0, left: 0.0, right: 0.0),
              child: FloatingNavBar(
                currentIndex: _currentPageIndex,
                onChanged: (index) => setState(() => _currentPageIndex = index),
                items: [
                  FloatingNavBarItem(icon: Icons.person_outline, label: 'General'),
                  FloatingNavBarItem(
                    icon: Icons.home_work_outlined,
                    label: 'Propiedades',
                    warningBadgeCount: currentMember.propertyRegistry.withDebt.length,
                  ),
                  FloatingNavBarItem(
                    icon: Icons.attach_money,
                    label: 'Pagos',
                    badgeCount: currentMember.paymentLedger.pendingPayments.length,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateWidget(MemberDetailsState state) {
    if (state is InitialState || state is LoadingState) {
      return const _MemberDetailsShimmer();
    }
    if (state is LoadedState) {
      return _buildBody(state.member);
    }
    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }
    return const UnknownStateView(key: ValueKey('unknown'));
  }

  Widget _buildBody(MemberEntity member) {
    // Switch between views based on FloatingNavBar index
    switch (_currentPageIndex) {
      case 1:
        return PropertyListView(member.propertyRegistry.properties);
      case 2:
        return PaymentListView(member.paymentLedger.payments);
      case 0:
      default:
        return _Overview(member: member);
    }
  }
}

// --- VIEW 1: OVERVIEW ---
class _Overview extends StatelessWidget {
  final MemberEntity member;
  const _Overview({required this.member});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(member.name[0].toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText.five(member.name),
                        BodyText.small('ID: ${member.user.id.split("-").first.toUpperCase()}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeaderText(text: 'RESUMEN FINANCIERO'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Balance Total',
                  value: CurrencyFormatter.fromCents(member.paymentLedger.totalBalanceInCents),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.hourglass_empty_rounded,
                  label: 'Pagos por Revisar',
                  value: CurrencyFormatter.fromCents(member.paymentLedger.pendingPaymentAmountInCents),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.warning_amber_rounded,
                  label: 'Deuda Vencida',
                  value: CurrencyFormatter.fromCents(member.propertyRegistry.totalOverdueFeeInCents),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- SHIMMER ---
class _MemberDetailsShimmer extends StatelessWidget {
  const _MemberDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceVariant.withOpacity(0.4),
      highlightColor: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
