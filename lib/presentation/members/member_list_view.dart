import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/members/member_card.dart';
import 'package:resipal_admin/presentation/users/user_card.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class MemberListView extends StatefulWidget {
  final List<MemberEntity> members;

  const MemberListView(this.members, {super.key});

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.members.isEmpty) return const _Empty();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => MemberCard(widget.members[index]),
            ),

            const SizedBox(height: 96.0),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.people_outline, size: 64, color: colorScheme.primary),
            ),
            const SizedBox(height: 32),
            HeaderText.four('Sin miembros', textAlign: TextAlign.center, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No hay miembros registrados en esta comunidad todavía.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: null, // Logic to be implemented
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Registrar miembro'),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
