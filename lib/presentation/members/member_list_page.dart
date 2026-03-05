import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/members/member_list_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/lib.dart';

class MemberListPage extends StatelessWidget {
  final MemberDirectoryEntity directory;
  const MemberListPage({required this.directory, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Miembros'),
      body: MemberListView(directory.members),
    );
  }
}
