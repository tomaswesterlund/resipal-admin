import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/applications/application_details/application_details_state.dart';
import 'package:resipal_core/lib.dart';

class ApplicationDetailsCubit extends Cubit<ApplicationDetailsState> {
  final LoggerService _logger = GetIt.I<LoggerService>();

  final WatchApplicationById _watchApplicationById = WatchApplicationById();
  StreamSubscription? _streamSubscription;

  ApplicationDetailsCubit() : super(InitialState());

  Future initialize(ApplicationEntity application) async {
    try {
      emit(LoadedState(application));

      _streamSubscription = _watchApplicationById
          .call(id: application.id)
          .listen(
            (application) async {
              emit(LoadedState(application));
            },
            onError: (e, s) {
              _logger.logException(
                featureArea: 'ApplicationDetailsCubit.initialize',
                exception: e,
                stackTrace: s,
                metadata: {'application': application.toMap()},
              );

              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'ApplicationDetailsCubit.initialize',
        stackTrace: s,
        metadata: {'application': application.toMap()},
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
