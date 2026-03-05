import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';
import 'package:shimmer/shimmer.dart';
import 'community_details_cubit.dart';
import 'community_details_state.dart';

class CommunityDetailsPage extends StatelessWidget {
  final CommunityEntity community;

  const CommunityDetailsPage({required this.community, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (ctx) => CommunityDetailsCubit()..initialize(community),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: const MyAppBar(title: 'Detalles de la Comunidad'),
        body: BlocBuilder<CommunityDetailsCubit, CommunityDetailsState>(
          builder: (ctx, state) {
            return StateSwitcher(child: _buildStateWidget(state));
          },
        ),
      ),
    );
  }

  Widget _buildStateWidget(CommunityDetailsState state) {
    if (state is InitialState || state is LoadingState) {
      return const _CommunityDetailsShimmer();
    }

    if (state is LoadedState) {
      return _Loaded(state.community, key: const ValueKey('loaded'));
    }

    if (state is ErrorState) {
      return const ErrorView(key: ValueKey('error'));
    }

    return const UnknownStateView(key: ValueKey('unknown'));
  }
}

class _Loaded extends StatelessWidget {
  final CommunityEntity community;

  const _Loaded(this.community, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Visual Header for Community
          _CommunityHeader(community),

          const SizedBox(height: 32),

          const SectionHeaderText(text: 'INFORMACIÓN GENERAL'),
          DefaultCard(
            child: Column(
              children: [
                DetailTile(icon: Icons.business_rounded, label: 'Nombre', value: community.name),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(icon: Icons.location_on_rounded, label: 'Ubicación', value: community.location),
                Divider(height: 1, color: colorScheme.outlineVariant),
                DetailTile(
                  icon: Icons.fingerprint_rounded,
                  label: 'ID de Comunidad',
                  value: '#${community.id.split('-').first.toUpperCase()}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Description Section
          if (community.description != null && community.description!.isNotEmpty) ...[
            const SectionHeaderText(text: 'DESCRIPCIÓN'),
            DefaultCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  community.description!,
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _CommunityHeader extends StatelessWidget {
  final CommunityEntity community;
  const _CommunityHeader(this.community);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(Icons.location_city_rounded, size: 40, color: colorScheme.primary),
          ),
          const SizedBox(height: 16),
          HeaderText.four(community.name, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          BodyText.medium(community.location, color: colorScheme.outline),
        ],
      ),
    );
  }
}

class _CommunityDetailsShimmer extends StatelessWidget {
  const _CommunityDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceVariant.withOpacity(0.4),
      highlightColor: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 24),
            Container(
              height: 120,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
