import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/properties/property_card.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_page.dart';
import 'package:resipal_admin/presentation/shared/colors/app_colors.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class PropertyListView extends StatefulWidget {
  final List<PropertyEntity> properties;

  const PropertyListView(this.properties, {super.key});

  @override
  State<PropertyListView> createState() => _PropertyListViewState();
}

class _PropertyListViewState extends State<PropertyListView> {
  late FilterSelectorItem<bool?> _selectedFilter;
  late List<FilterSelectorItem<bool?>> _filterOptions;

  @override
  void initState() {
    super.initState();
    _filterOptions = [
      const FilterSelectorItem(label: 'Todas', value: null),
      const FilterSelectorItem(label: 'Con deuda', value: true),
    ];
    _selectedFilter = _filterOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter Logic: based on the hasDebt getter
    final filteredProperties = _selectedFilter.value == null
        ? widget.properties
        : widget.properties.where((p) => p.hasDebt == _selectedFilter.value).toList();

    // 2. Sort by name
    filteredProperties.sort((a, b) => a.name.compareTo(b.name));

    if (widget.properties.isEmpty) return const _Empty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Generic Filter Selector
            FilterSelector<bool?>(
              options: _filterOptions,
              selectedValue: _selectedFilter,
              onSelected: (newItem) {
                setState(() {
                  _selectedFilter = newItem;
                });
              },
            ),

            const SizedBox(height: 16.0),

            if (filteredProperties.isEmpty)
              _buildEmptyFilterState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProperties.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) => PropertyCard(filteredProperties[index]),
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
          Icon(Icons.verified_user_outlined, color: AppColors.success.withOpacity(0.5), size: 48),
          const SizedBox(height: 12),
          Text(
            _selectedFilter.value == true ? '¡Excelente! No hay unidades con deuda' : 'No hay unidades que coincidan',
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
              child: Icon(Icons.home_work_outlined, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin propiedades', textAlign: TextAlign.center, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Aún no has dado de alta ninguna unidad en esta sección.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => Go.to(const RegisterPropertyPage()),
              icon: const Icon(Icons.add),
              label: const Text('Registrar propiedad'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
