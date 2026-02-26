import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool canSubmit;
  final bool isLoading;
  final Color backgroundColor;

  const CustomButton({
    required this.label,
    this.onPressed,
    required this.backgroundColor,
    this.canSubmit = false,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = canSubmit && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          // Common styling for disabled state
          disabledBackgroundColor: backgroundColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: isEnabled ? 2 : 0,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                label,
                style: GoogleFonts.raleway(
                  color: isEnabled ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
