import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_core/lib.dart';
import 'member_breakdown_report_state.dart';

class MemberBreakdownReportCubit extends Cubit<MemberBreakdownReportState> {
  final AdminSessionService _session = GetIt.I<AdminSessionService>();

  MemberBreakdownReportCubit() : super(InitialState());

  void initialize({required bool onlyDebtors}) {
    emit(LoadingState());
    try {
      final communityId = _session.communityId;
      final community = GetCommunityById().call(communityId);
      final directory = community.memberDirectory;

      final members = onlyDebtors
          ? directory.members.where((m) => m.propertyRegistry.hasDebt).toList()
          : directory.members;

      final totalDebt = members.fold<int>(0, (sum, m) => sum + m.propertyRegistry.totalOverdueFeeInCents);
      final totalBalance = members.fold<int>(0, (sum, m) => sum + m.paymentLedger.totalBalanceInCents);
      
      // Calculate Pending Payments
      final totalPending = members.fold<int>(0, (sum, m) => sum + m.paymentLedger.pendingPaymentAmountInCents);

      emit(LoadedState(
        community: community,
        members: members,
        totalDebtCents: totalDebt,
        totalBalanceCents: totalBalance,
        totalPendingCents: totalPending,
      ));
    } catch (e) {
      emit(ErrorState());
    }
  }
}