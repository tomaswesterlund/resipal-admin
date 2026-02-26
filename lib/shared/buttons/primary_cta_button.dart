import 'package:resipal_admin/shared/app_colors.dart';
import 'custom_button.dart';

class PrimaryCtaButton extends CustomButton {
  const PrimaryCtaButton({required super.label, super.onPressed, super.canSubmit = true, super.isLoading = false, super.key})
    : super(backgroundColor: AppColors.primary);
}
