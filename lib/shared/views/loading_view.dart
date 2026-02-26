import 'package:flutter/material.dart';
import 'package:resipal_core/presentation/shared/colors/base_app_colors.dart';
import 'package:resipal_core/presentation/shared/resipal_logo.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';

class LoadingView extends StatelessWidget {
  final String title;
  final String? description;
  const LoadingView({this.title = 'Cargando información...', this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(opacity: 0.8, child: ResipalLogo()),
          const SizedBox(height: 40),
          // A sleek, thin progress bar
          const SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              backgroundColor: BaseAppColors.background,
              color: BaseAppColors.secondary,
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
