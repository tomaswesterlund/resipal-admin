import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/members/member_details/member_details_state.dart';
import 'package:resipal_core/lib.dart';

class MemberDetailsCubit extends Cubit<MemberDetailsState> {
  final LoggerService _logger = GetIt.I<LoggerService>();

  // Assuming a WatchMemberById use case exists, similar to your application one
  final WatchMemberByCommunityAndUserId _watchMember = WatchMemberByCommunityAndUserId();
  StreamSubscription? _streamSubscription;

  MemberDetailsCubit() : super(InitialState());

  Future initialize(MemberEntity member) async {
    try {
      emit(LoadedState(member));

      _streamSubscription = _watchMember
          .call(
            communityId: member.community.id,
            userId: member.user.id
            )
          .listen(
            (updatedMember) async {
              emit(LoadedState(updatedMember));
            },
            onError: (e, s) {
              _logger.logException(
                featureArea: 'MemberDetailsCubit.initialize',
                exception: e,
                stackTrace: s,
                metadata: {'member': member.toMap()},
              );
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'MemberDetailsCubit.initialize',
        stackTrace: s,
        metadata: {'member': member.toMap()},
      );
      emit(ErrorState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
