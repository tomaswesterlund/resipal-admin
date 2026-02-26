import 'package:flutter/material.dart';
import 'package:resipal_admin/shared/buttons/custom_button.dart';

class SuccessButton extends CustomButton {
  SuccessButton({required super.label, super.onPressed, super.canSubmit = true, super.isLoading = false, super.key})
    : super(backgroundColor: Colors.green[600]!);
}
