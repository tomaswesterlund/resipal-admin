import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/admin_session_service.dart';
import 'package:resipal_admin/presentation/users/user_list/user_list_state.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/ui/filter_selector.dart';

enum UserFilter { all, admins, residents, security }

enum ResidentFilter { all, debtors }

class UserListCubit extends Cubit<UserListState> {
  final LoggerService _logger = GetIt.I<LoggerService>();
  final AdminSessionService _sessionService = GetIt.I<AdminSessionService>();

  final WatchMembershipsByCommunity _watchMembers = WatchMembershipsByCommunity();
  StreamSubscription? _streamSubscription;

  final List<FilterSelectorItem> userFilterItems = [
    FilterSelectorItem(label: 'Todos', value: UserFilter.all),
    FilterSelectorItem(label: 'Admins', value: UserFilter.admins),
    FilterSelectorItem(label: 'Residentes', value: UserFilter.residents),
    FilterSelectorItem(label: 'Seguridad', value: UserFilter.security),
  ];

  late FilterSelectorItem selectedUserFilter;

  final List<FilterSelectorItem> residentFilterItems = [
    FilterSelectorItem(label: 'Todos', value: ResidentFilter.all),
    FilterSelectorItem(label: 'Morosos', value: ResidentFilter.debtors),
  ];

  late FilterSelectorItem selectedResidentFilter;

  late List<MembershipEntity> allUsers;

  UserListCubit() : super(InitialState());

  Future<void> initialize() async {
    try {
      emit(LoadingState());

      final communityId = _sessionService.communityId;
      selectedUserFilter = userFilterItems.first;
      selectedResidentFilter = residentFilterItems.first;

      _streamSubscription = _watchMembers
          .call(communityId)
          .listen(
            (users) {
              allUsers = users;

              if (users.isEmpty) {
                emit(EmptyState());
                return;
              }

              emit(
                LoadedState(
                  users: users,
                  userFilterItems: userFilterItems,
                  selectedUserFilter: selectedUserFilter,
                  residentFilterItems: residentFilterItems,
                  selectedResidentFilter: selectedResidentFilter,
                ),
              );
            },
            onError: (e, s) {
              _logger.logException(exception: e, stackTrace: s, featureArea: 'MemberListCubit.initialize / listener');
              emit(ErrorState());
            },
          );
    } catch (e, s) {
      _logger.logException(exception: e, stackTrace: s, featureArea: 'MemberListCubit.initialize');
      emit(ErrorState());
    }
  }

  void onUserFilterChanged(FilterSelectorItem newUserFilter) {
    selectedUserFilter = newUserFilter;
    _applyFilters();
  }

  void onResidentFilterChanged(FilterSelectorItem newResidentFilter) {
    selectedResidentFilter = newResidentFilter;
    _applyFilters();
  }

  void _applyFilters() {
    // 1. Start with the full list
    var filteredUsers = List<MembershipEntity>.from(allUsers);

    // 2. Apply User Type Filter (Admin, Resident, Security)
    if (selectedUserFilter.value == UserFilter.admins) {
      filteredUsers = filteredUsers.where((x) => x.isAdmin).toList();
    } else if (selectedUserFilter.value == UserFilter.residents) {
      filteredUsers = filteredUsers.where((x) => x.isResident).toList();
    } else if (selectedUserFilter.value == UserFilter.security) {
      filteredUsers = filteredUsers.where((x) => x.isSecurity).toList();
    }

    // 3. Apply Debt Filter (Only if a resident is selected or applicable)
    if (selectedResidentFilter.value == ResidentFilter.debtors) {
      // We filter for those who ARE residents AND have debt
      filteredUsers = filteredUsers.where((x) => x.isResident && x.resident.propertyRegistery.hasDebt).toList();
    }

    // 4. Always sort the result
    filteredUsers.sort((a, b) => a.resident.user.name.toLowerCase().compareTo(b.resident.user.name.toLowerCase()));

    emit(
      LoadedState(
        users: filteredUsers,
        userFilterItems: userFilterItems,
        selectedUserFilter: selectedUserFilter,
        residentFilterItems: residentFilterItems,
        selectedResidentFilter: selectedResidentFilter,
      ),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
