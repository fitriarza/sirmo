import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Jika null, tombol otomatis berubah jadi mode disabled (loading)
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          // Gunakan warna gradient medis andalanmu cokk
          gradient: onPressed == null 
              ? null 
              : const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
          color: onPressed == null ? Colors.grey[300] : null, // Warna abu-abu kalau lagi loading
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          boxShadow: onPressed == null 
              ? null 
              : [
                  BoxShadow(
                    color: AppColors.medisPrimary.withValues(alpha: 0.3), 
                    blurRadius: 12, 
                    offset: const Offset(0, 6)
                  )
                ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.fontReguler,
                    fontWeight: AppSizes.fontBoldWeight,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}