import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class FailureScreen extends StatelessWidget {
  final String reason;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  const FailureScreen({
    super.key,
    required this.reason,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.dangerBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Payment Failed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                reason,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSoft,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Try Again",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Cancel and Go Home",
                  style: TextStyle(
                    color: AppColors.textSoft,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
