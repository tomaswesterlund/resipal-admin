import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/users/user_card.dart';
import 'package:resipal_admin/presentation/users/user_list/user_list_cubit.dart';
import 'package:resipal_admin/presentation/users/user_list/user_list_state.dart';
import 'package:wester_kit/lib.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListCubit()..initialize(),
      child: BlocBuilder<UserListCubit, UserListState>(
        builder: (context, state) {
          if (state is LoadingState) return const LoadingView();

          if (state is ErrorState) return const ErrorView();

          if (state is EmptyState) return const _Empty();

          if (state is LoadedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FilterSelector(
                      options: state.userFilterItems,
                      selectedValue: state.selectedUserFilter,
                      onSelected: (newFilter) => context.read<UserListCubit>().onUserFilterChanged(newFilter),
                    ),
                    SizedBox(height: 16.0),
                    if (state.selectedUserFilter.value == UserFilter.residents) ...[
                      FilterSelector(
                        options: state.residentFilterItems,
                        selectedValue: state.selectedResidentFilter,
                        onSelected: (newFilter) => context.read<UserListCubit>().onResidentFilterChanged(newFilter),
                      ),
                      SizedBox(height: 16.0),
                    ],
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => UserCard(state.users[index]),
                    ),
                    SizedBox(height: 96.0),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFF1A4644).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.people_outline, size: 64, color: Color(0xFF1A4644)),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin usuarios', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios registrados en esta comunidad todavía.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: null, //() => Go.to(const RegisterMemberPage()),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Registrar miembro'),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A4644)),
            ),
          ],
        ),
      ),
    );
  }
}
