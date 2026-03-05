import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_core/lib.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final WatchPropertyById _watchProperty = WatchPropertyById();
  final LoggerService _logger = GetIt.I<LoggerService>();
  StreamSubscription? _subscription;

  PropertyDetailsCubit() : super(LoadingState());

  void initialize(PropertyEntity property) {
    emit(LoadedState(property));

    _subscription?.cancel();

    _subscription = _watchProperty(property.id).listen(
      (property) => emit(LoadedState(property)),
      onError: (e, s) {
        _logger.logException(
          exception: e,
          stackTrace: s,
          featureArea: 'PropertyDetailsCubit.initialize',
          metadata: {'property': property.toMap()},
        );
        emit(ErrorState());
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
