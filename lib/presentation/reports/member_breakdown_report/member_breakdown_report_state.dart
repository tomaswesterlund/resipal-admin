import 'package:equatable/equatable.dart';
import 'package:resipal_core/lib.dart';

abstract class MemberBreakdownReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MemberBreakdownReportState {}
class LoadingState extends MemberBreakdownReportState {}
class ErrorState extends MemberBreakdownReportState {}

class LoadedState extends MemberBreakdownReportState {
  final CommunityEntity community;
  final List<MemberEntity> members;
  final int totalDebtCents;
  final int totalBalanceCents;
  final int totalPendingCents; // Added field

  LoadedState({
    required this.community,
    required this.members,
    required this.totalDebtCents,
    required this.totalBalanceCents,
    required this.totalPendingCents,
  });

  @override
  List<Object?> get props => [members, totalDebtCents, totalBalanceCents, totalPendingCents];
}