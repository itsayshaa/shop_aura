import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/screens/payment/payment_types.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class PaymentMethodsSection extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodsSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final methods = [
      (PaymentMethod.card, "Credit / Debit Card", Icons.credit_card_rounded),
      (PaymentMethod.upi, "UPI", Icons.qr_code_rounded),
      (PaymentMethod.wallet, "Wallet", Icons.account_balance_wallet_outlined),
      (PaymentMethod.cod, "Cash on Delivery", Icons.payments_outlined),
    ];

    return Column(
      children: methods.map((m) {
        final (method, label, icon) = m;
        final isSelected = selected == method;
        return InkWell(
          onTap: () => onChanged(method),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              color: isSelected ? AppColors.primary.withOpacity(0.06) : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textSoft),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5))),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: isSelected ? AppColors.primary : AppColors.textSoft,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}