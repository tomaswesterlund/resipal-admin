import 'package:flutter/material.dart';
import 'package:resipal_admin/shared/app_colors.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';

class LoadingBar extends StatelessWidget {
  final String title;
  final String? description;
  const LoadingBar({this.title = 'Cargando información...', this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              backgroundColor: AppColors.background,
              color: AppColors.secondary,
              minHeight: 2,
            ),
          ),
          const SizedBox(height: 24),
          HeaderText.four(title, textAlign: TextAlign.center),
          if (description != null) ...[
            const SizedBox(height: 8),
            BodyText.small(description!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
