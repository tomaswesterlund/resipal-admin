import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/shared/app_colors.dart';

class AmountInputField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isRequired;
  final String? helpText;
  final Function(double) onChanged;

  const AmountInputField({
    required this.label,
    this.hint = '0.00',
    this.isRequired = false,
    this.helpText,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Label Area (Consistent with TextInputField) ---
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.raleway(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: GoogleFonts.raleway(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (helpText != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showHelpDialog(context),
                  child: Icon(
                    Icons.help_outline_rounded,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),

        // --- Input Area ---
        TextFormField(
          maxLines: 1,
          onChanged: (value) {
            final double? amount = double.tryParse(value);
            onChanged(amount ?? 0.0);
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // Allow digits and only one decimal point (max 2 decimals)
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: GoogleFonts.raleway(fontSize: 16.0, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
            hintStyle: GoogleFonts.raleway(
              fontSize: 16.0,
              color: Colors.grey.shade500,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 18.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          label,
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        content: Text(helpText!, style: GoogleFonts.raleway()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}