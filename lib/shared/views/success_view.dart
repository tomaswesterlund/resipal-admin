import 'package:flutter/material.dart';
import 'package:resipal_admin/shared/buttons/success_button.dart';
import 'package:resipal_core/presentation/shared/texts/body_text.dart';
import 'package:resipal_core/presentation/shared/texts/header_text.dart';

class SuccessView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onActionButtonPressed;
  final String? actionButtonLabel;

  const SuccessView({
    required this.title,
    this.subtitle,
    this.onActionButtonPressed,
    this.actionButtonLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Green Checkmark Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
              child: Icon(Icons.check_circle_rounded, color: Colors.green[600], size: 80),
            ),
            const SizedBox(height: 24),

            // Dynamic Text
            HeaderText.two(title),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              BodyText.small(subtitle!, textAlign: TextAlign.center),
            ],

            const SizedBox(height: 40),

            // Optional action button (e.g., "Volver al inicio")
            if (onActionButtonPressed != null && actionButtonLabel != null)
              SizedBox(
                width: double.infinity,
                child: SuccessButton(label: actionButtonLabel!, onPressed: onActionButtonPressed,),
              ),
          ],
        ),
      ),
    );
  }
}
