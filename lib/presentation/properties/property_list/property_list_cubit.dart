import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'property_list_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class PropertyListCubit extends Cubit<PropertyListState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchPropertiesByCommunity _watchProperties = WatchPropertiesByCommunity();
  StreamSubscription? _streamSubscription;

  PropertyListCubit() : super(InitialState());

  Future<void> initialize() async {
    try {
      emit(LoadingState());

      final communityId = _sessionService.communityId;

      _streamSubscription = _watchProperties
          .call(communityId)
          .listen(
            (properties) {
              if (properties.isEmpty) {
                emit(EmptyState());
              } else {
                emit(LoadedState(properties));
              }
            },
            onError: (e, s) {
              _logger.logException(
                exception: e, 
                stackTrace: s, 
                featureArea: 'PropertyListCubit.initialize / listener'
              );
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e, 
        stackTrace: s, 
        featureArea: 'PropertyListCubit.initialize'
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