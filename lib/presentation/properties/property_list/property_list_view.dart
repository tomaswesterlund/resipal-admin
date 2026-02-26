import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/presentation/properties/property_card.dart';
import 'package:resipal_admin/presentation/properties/property_list/property_list_cubit.dart';
import 'package:resipal_admin/presentation/properties/property_list/property_list_state.dart';
import 'package:resipal_admin/presentation/properties/register_property/register_property_page.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:short_navigation/short_navigation.dart';

class PropertyListView extends StatelessWidget {
  const PropertyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyListCubit()..initialize(),
      child: BlocBuilder<PropertyListCubit, PropertyListState>(
        builder: (context, state) {
          if (state is LoadingState) return const LoadingView();

          if (state is ErrorState) {
            return ErrorView();
          }

          if (state is EmptyState) return const _Empty();

          if (state is LoadedState) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: state.properties.length,
              itemBuilder: (context, index) => PropertyCard(state.properties[index]),
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
      // Centered for standalone view
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFF1A4644).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.home_work_outlined, size: 64, color: Color(0xFF1A4644)),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin propiedades', textAlign: TextAlign.center, color: const Color(0xFF1A4644)),
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
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A4644)),
            ),
          ],
        ),
      ),
    );
  }
}
