import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resipal_admin/shared/app_colors.dart';

class DynamicSelector extends StatelessWidget {
  final List<DynamicSelectorItem> options;
  final DynamicSelectorItem selectedValue;
  final Function(DynamicSelectorItem) onSelected;

  const DynamicSelector({super.key, required this.options, required this.selectedValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.auxiliarScale[100]!),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedValue == option;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    color: isSelected ? Colors.white : const Color(0xFF0D2321),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DynamicSelectorItem {
  final String label;
  final String value;

  DynamicSelectorItem({required this.label, required this.value});
}
