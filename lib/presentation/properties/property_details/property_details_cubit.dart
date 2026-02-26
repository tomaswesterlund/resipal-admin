import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_core/lib.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final String propertyId;
  final WatchPropertyById _watchProperty = WatchPropertyById();
  final LoggerService _logger = GetIt.I<LoggerService>();
  StreamSubscription? _subscription;

  PropertyDetailsCubit({required this.propertyId}) : super(LoadingState());

  void initialize() {
    _subscription?.cancel();
    _subscription = _watchProperty(propertyId).listen(
      (property) => emit(LoadedState(property)),
      onError: (e, s) {
        _logger.logException(exception: e, stackTrace: s, featureArea: 'PropertyDetailsCubit.initialize');
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
