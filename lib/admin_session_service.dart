import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:resipal_core/lib.dart';
import 'package:rxdart/rxdart.dart';

class AdminSessionService {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final CompositeSubscription _subscriptions = CompositeSubscription();

  String? _communityId;

  // Updated Getter
  String get communityId {
    if (_communityId == null) {
      _logAndThrowMissingSession('communityId');
    }
    return _communityId!;
  }

  String? _userId;

  String get userId {
    if (_userId == null) {
      _logAndThrowMissingSession('userId');
    }
    return _userId!;
  }

  void _logAndThrowMissingSession(String fieldName) {
    final error = StateError(
      'Attempted to access $fieldName before AdminSessionService was initialized. '
      'Ensure startWatchers() has been called and awaited.',
    );

    _logger.logException(
      featureArea: 'AdminSessionService.$fieldName',
      exception: error,
      metadata: {'status': 'uninitialized_access'},
    );

    throw error;
  }

  Future<void> startWatchers({required String communityId, required String userId}) async {
    _subscriptions.clear();

    _communityId = communityId;
    _userId = userId;

    try {
      await Future.wait([
        _setupSubscription(GetIt.I<CommunityDataSource>().watchById(communityId)),
        _setupSubscription(GetIt.I<UserDataSource>().watchById(userId)),
        _setupSubscription(GetIt.I<ApplicationDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<InvitationDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<ContractDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<MembershipDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<MaintenanceFeeDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<PaymentDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<PropertyDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<VisitorDataSource>().watchByCommunityId(communityId)),
      ]);
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'AdminSessionService.startWatchers',
        stackTrace: s,
        metadata: {'communityId': communityId, 'userId': userId},
      );
    }
  }

  Future<void> _setupSubscription<T>(Stream<T> stream) async {
    await stream.first;
    final sub = stream.listen((_) {});
    _subscriptions.add(sub);
  }

  void dispose() {
    _subscriptions.dispose();
  }
}
