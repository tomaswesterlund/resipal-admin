import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_admin/presentation/users/user_card.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class UserListView extends StatefulWidget {
  final List<MembershipEntity> memberships;

  const UserListView(this.memberships, {super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late FilterSelectorItem<String?> _selectedFilter;
  late List<FilterSelectorItem<String?>> _filterOptions;

  @override
  void initState() {
    super.initState();
    _filterOptions = [
      const FilterSelectorItem(label: 'Todos', value: 'all'),
      const FilterSelectorItem(label: 'Administradores', value: 'admin'),
      const FilterSelectorItem(label: 'Residentes', value: 'resident'),
      const FilterSelectorItem(label: 'Seguridad', value: 'security'),
    ];
    _selectedFilter = _filterOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter Logic based on your MembershipEntity boolean flags
    final filteredMemberships = widget.memberships.where((m) {
      switch (_selectedFilter.value) {
        case 'admin':
          return m.isAdmin;
        case 'resident':
          return m.isResident;
        case 'security':
          return m.isSecurity;
        default:
          return true; // 'all'
      }
    }).toList();

    // 2. Sort by resident name (alphabetical)
    filteredMemberships.sort(
      (a, b) => (a.resident.user.name).toLowerCase().compareTo((b.resident.user.name).toLowerCase()),
    );

    if (widget.memberships.isEmpty) return const _Empty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Filter Selector using String values to represent your booleans
            FilterSelector<String?>(
              options: _filterOptions,
              selectedValue: _selectedFilter,
              onSelected: (newItem) {
                setState(() {
                  _selectedFilter = newItem;
                });
              },
            ),

            const SizedBox(height: 16.0),

            if (filteredMemberships.isEmpty)
              _buildEmptyFilterState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredMemberships.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                // Note: Passing m.resident as per your MembershipEntity definition
                itemBuilder: (context, index) => UserCard(filteredMemberships[index]),
              ),

            const SizedBox(height: 96.0),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFilterState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Icon(Icons.person_search_outlined, color: AppColors.primary.withOpacity(0.5), size: 48),
          const SizedBox(height: 12),
          Text(
            'No hay usuarios con este rol en la comunidad',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
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
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.people_outline, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin usuarios', textAlign: TextAlign.center, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios registrados en esta comunidad todavía.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Registrar miembro'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
