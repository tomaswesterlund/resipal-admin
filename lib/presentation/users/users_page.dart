import 'package:flutter/material.dart';
import 'package:resipal_admin/presentation/users/user_list_view.dart';
import 'package:resipal_core/lib.dart';
import 'package:wester_kit/ui/my_app_bar.dart';

class UsersPage extends StatelessWidget {
  final List<UserEntity> users;
  const UsersPage(this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Usuarios'),
      body: UserListView(users)
    );
  }
}