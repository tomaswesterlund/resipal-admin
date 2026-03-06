import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:resipal_core/lib.dart';
import 'package:rxdart/rxdart.dart';

class AdminSessionService {
  final LoggerService _logger = GetIt.I<LoggerService>();

  // CompositeSubscription is perfect here as it tracks all subs in one place
  final CompositeSubscription _subscriptions = CompositeSubscription();

  String? _communityId;
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
  }

  // ... (Your existing Getters and _logAndThrowMissingSession)

  Future<void> startWatchers({required String communityId, required String userId}) async {
    // 1. Clean up any existing session before starting a new one
    await stopWatchers();

    _communityId = communityId;
    _userId = userId;

    try {
      // 2. We await the first data emission for all critical data sources
      // This ensures the Cubits find data in the cache immediately upon UI load.
      await Future.wait([
        _setupSubscription(GetIt.I<CommunityDataSource>().watchById(communityId)),
        _setupSubscription(GetIt.I<UserDataSource>().watchById(userId)),

        _setupSubscription(GetIt.I<ApplicationDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<ContractDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<EmailInvitationDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<ContractDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<InvitationDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<MaintenanceFeeDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<MembershipDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<PaymentDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<PropertyDataSource>().watchByCommunityId(communityId)),
        _setupSubscription(GetIt.I<VisitorDataSource>().watchByCommunityId(communityId)),
      ]);

      _logger.info('Watchers started successfully for community: $communityId');
    } catch (e, s) {
      _logger.logException(
        exception: e,
        featureArea: 'AdminSessionService.startWatchers',
        stackTrace: s,
        metadata: {'communityId': communityId, 'userId': userId},
      );
      rethrow;
    }
  }

  /// Stops all active real-time listeners and clears the session state.
  /// Call this during logout or when switching communities.
  Future<void> stopWatchers() async {
    try {
      // Clear cancels all internal subscriptions but keeps the CompositeSubscription reusable
      _subscriptions.clear();

      // Nullify IDs to prevent unauthorized access to the old session
      _communityId = null;
      _userId = null;

      _logger.info('AdminSessionService: All watchers stopped and session cleared.');
    } catch (e, s) {
      _logger.logException(exception: e, featureArea: 'AdminSessionService.stopWatchers', stackTrace: s);
    }
  }

  Future<void> _setupSubscription<T>(Stream<T> stream) async {
    // Ensure data is in the repository/cache before moving forward
    await stream.first;

    // We listen to keep the stream 'hot' in the repository.
    // The CompositeSubscription will handle the cancellation automatically.
    final sub = stream.listen((data) {
      /* Repository is updated internally by the DataSources */
    }, onError: (e) => _logger.logException(exception: e, featureArea: 'AdminSessionService.Stream'));

    _subscriptions.add(sub);
  }

  void dispose() {
    stopWatchers();
    _subscriptions.dispose(); // Permanent disposal of the container
  }
}
