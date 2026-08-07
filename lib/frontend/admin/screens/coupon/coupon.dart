import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_aura/backend/models/client/coupon/CouponModel.dart';
import 'package:shop_aura/frontend/admin/service/couponService.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'coupon_list.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
enum DiscountType {
  percentOff,
  flatOff,
  balanceOff,
  freeShipping,
  buyOneGetOne,
}

extension DiscountTypeX on DiscountType {
  String get label {
    switch (this) {
      case DiscountType.percentOff:
        return '% Off';
      case DiscountType.flatOff:
        return 'Flat Off';
      case DiscountType.balanceOff:
        return 'Balance / Cashback Off';
      case DiscountType.freeShipping:
        return 'Free Shipping';
      case DiscountType.buyOneGetOne:
        return 'Buy 1 Get 1';
    }
  }

  IconData get icon {
    switch (this) {
      case DiscountType.percentOff:
        return Icons.percent_rounded;
      case DiscountType.flatOff:
        return Icons.sell_rounded;
      case DiscountType.balanceOff:
        return Icons.account_balance_wallet_rounded;
      case DiscountType.freeShipping:
        return Icons.local_shipping_rounded;
      case DiscountType.buyOneGetOne:
        return Icons.redeem_rounded;
    }
  }

  bool get needsValue =>
      this == DiscountType.percentOff ||
      this == DiscountType.flatOff ||
      this == DiscountType.balanceOff;

  bool get needsMaxDiscount => this == DiscountType.percentOff;
}

// ============================================================
// REUSABLE FORM PIECES (label, text field, dropdown, switch, buttons)
// ============================================================

class FormLabel extends StatelessWidget {
  final String text;
  final bool required;
  const FormLabel(this.text, {super.key, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          children: [
            if (required)
              const TextSpan(
                text: '  *',
                style: TextStyle(color: AppColors.danger),
              ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration({
  required String hint,
  IconData? prefixIcon,
  String? prefixText,
  Widget? suffixIcon,
}) {
  OutlineInputBorder border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13.5),
    filled: true,
    fillColor: AppColors.background,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 19, color: AppColors.textGrey)
        : null,
    prefixText: prefixText,
    prefixStyle: const TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w700,
      fontSize: 13.5,
    ),
    suffixIcon: suffixIcon,
    border: border(AppColors.border),
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.primary, width: 1.4),
    errorBorder: border(AppColors.danger),
    focusedErrorBorder: border(AppColors.danger, width: 1.4),
    errorStyle: const TextStyle(color: AppColors.danger, fontSize: 11.5),
  );
}

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool required;
  final IconData? prefixIcon;
  final String? prefixText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.required = false,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: AppColors.primary,
          decoration: _fieldDecoration(
            hint: hint,
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            suffixIcon: suffixIcon,
          ),
          validator:
              validator ??
              (required
                  ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
                  : null),
        ),
      ],
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final bool required;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final IconData Function(T)? itemIcon;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.required = false,
    this.itemIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label, required: required),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textGrey,
          ),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          decoration: _fieldDecoration(hint: ''),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Row(
                    children: [
                      if (itemIcon != null) ...[
                        Icon(itemIcon!(e), size: 17, color: AppColors.primary),
                        const SizedBox(width: 8),
                      ],
                      Text(itemLabel(e)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class AppSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 50,
      width: expand ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: onPressed == null && !loading
            ? null
            : AppColors.primaryGradient,
        color: (onPressed == null && !loading) ? AppColors.border : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: (onPressed == null)
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(AppColors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AppColors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
    );

    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: loading ? null : onPressed,
        child: child,
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: 50,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1.3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CouponFormScreen extends StatefulWidget {
  final CouponModel? coupon;
  const CouponFormScreen({super.key,this.coupon});

  @override
  State<CouponFormScreen> createState() => _CouponFormScreenState();
}

class _CouponFormScreenState extends State<CouponFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codeCtrl = TextEditingController(text: 'SAVE50');
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _maxDiscountCtrl = TextEditingController();
  final _minPurchaseCtrl = TextEditingController();
  final _usageLimitCtrl = TextEditingController();

  DiscountType _type = DiscountType.percentOff;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;
  bool _oneTimePerUser = false;
  bool _submitting = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _valueCtrl.dispose();
    _maxDiscountCtrl.dispose();
    _minPurchaseCtrl.dispose();
    _usageLimitCtrl.dispose();
    super.dispose();
  }

  void _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = DateTime.now().millisecondsSinceEpoch;
    final code = List.generate(
      8,
      (i) => chars[(rnd ~/ (i + 1)) % chars.length],
    ).join();
    setState(() => _codeCtrl.text = code);
  }
@override
void initState() {
  super.initState();

  if (widget.coupon != null) {
    final c = widget.coupon!;

    _codeCtrl.text = c.code;
    _titleCtrl.text = c.name;
    _descCtrl.text = c.description;
    _valueCtrl.text = c.discount.toString();
    _maxDiscountCtrl.text = c.maximumDiscount.toString();
    _minPurchaseCtrl.text = c.minimumOrderAmount.toString();
    _usageLimitCtrl.text = c.usageLimit.toString();

    _startDate = c.createdAt;
    _endDate = c.expiryDate;

    _isActive = c.status == "Active";

    _type = DiscountType.values.firstWhere(
      (e) => e.label == c.type,
      orElse: () => DiscountType.percentOff,
    );
  }
}
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _submit() async {
    String message;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_type.needsValue && _valueCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('Please enter a discount value'),
        ),
      );
      return;
    }
    if (_endDate != null &&
        _startDate != null &&
        _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('End date cannot be before start date'),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    final coupon = CouponModel(
      id: mongo.ObjectId(),
      name: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      type: _type.label,
      discount: double.tryParse(_valueCtrl.text) ?? 0,
      expiryDate: _endDate!,
      minimumOrderAmount: double.tryParse(_minPurchaseCtrl.text) ?? 0,
      maximumDiscount: double.tryParse(_maxDiscountCtrl.text) ?? 0,
      usageLimit: int.tryParse(_usageLimitCtrl.text) ?? 0,
      status: _isActive ? "Active" : "Inactive",
    );
    if(widget.coupon == null){
    message = await CouponService.instance.createCoupon(coupon);
    }else{
      message = await CouponService.instance.updateCoupon(
        widget.coupon!.id!,
        coupon
        );
    }
    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _SectionCard(
            title: 'Coupon Code',
            children: [
              AppTextField(
                label: 'Code',
                required: true,
                controller: _codeCtrl,
                hint: 'e.g. SAVE50',
                prefixIcon: Icons.confirmation_number_outlined,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(15),
                ],
                suffixIcon: IconButton(
                  tooltip: 'Generate code',
                  icon: const Icon(
                    Icons.autorenew_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  onPressed: _generateCode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Details',
            children: [
              AppTextField(
                label: 'Title',
                required: true,
                controller: _titleCtrl,
                hint: 'e.g. 50% Off Storewide',
                prefixIcon: Icons.title_rounded,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Description',
                controller: _descCtrl,
                required: true,
                hint: 'Short description shown to customers',
                maxLines: 3,
                prefixIcon: Icons.notes_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Discount',
            children: [
              AppDropdown<DiscountType>(
                label: 'Discount Type',
                required: true,
                value: _type,
                items: DiscountType.values,
                itemLabel: (t) => t.label,
                itemIcon: (t) => t.icon,
                onChanged: (v) => setState(() => _type = v!),
              ),
              if (_type.needsValue) ...[
                const SizedBox(height: 14),
                AppTextField(
                  label: _type == DiscountType.percentOff
                      ? 'Percentage Value'
                      : 'Amount',
                  required: true,
                  controller: _valueCtrl,
                  hint: _type == DiscountType.percentOff
                      ? 'e.g. 50'
                      : 'e.g. 200',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefixText: _type == DiscountType.percentOff ? null : '₹  ',
                  suffixIcon: _type == DiscountType.percentOff
                      ? const Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Icon(
                            Icons.percent_rounded,
                            size: 18,
                            color: AppColors.textGrey,
                          ),
                        )
                      : null,
                ),
              ],
              if (_type.needsMaxDiscount) ...[
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Max Discount Cap',
                  controller: _maxDiscountCtrl,
                  hint: 'e.g. 500',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefixText: '₹  ',
                  required: true,
                ),
              ],
              const SizedBox(height: 14),
              AppTextField(
                label: 'Minimum Purchase',
                controller: _minPurchaseCtrl,
                hint: 'e.g. 999',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixText: '₹  ',
                required: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Validity',
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      required: true,
                      label: 'Start Date',
                      controller: TextEditingController(
                        text: _formatDate(_startDate),
                      ),
                      hint: 'Select date',
                      readOnly: true,
                      prefixIcon: Icons.event_rounded,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      required: true,
                      label: 'End Date',
                      controller: TextEditingController(
                        text: _formatDate(_endDate),
                      ),
                      hint: 'Select date',
                      readOnly: true,
                      prefixIcon: Icons.event_busy_rounded,
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Usage Limit (per coupon)',
                controller: _usageLimitCtrl,
                required: true,
                hint: 'e.g. 100 (leave blank for unlimited)',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixIcon: Icons.repeat_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Rules',
            children: [
              AppSwitchTile(
                title: 'One-time use per user',
                subtitle: 'Each customer can redeem this coupon only once',
                value: _oneTimePerUser,
                onChanged: (v) => setState(() => _oneTimePerUser = v),
              ),
              const SizedBox(height: 10),
              AppSwitchTile(
                title: 'Active',
                subtitle:
                    'Coupon is visible and usable by customers immediately',
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
          SizedBox(height: 15),
          PrimaryButton(
            label: widget.coupon == null ? "Create Coupen" : "Update Coupon",
            icon: Icons.check_circle,
            loading: _submitting,
            onPressed: _submit,
          ),
          SizedBox(height: 15,),
          PrimaryButton(
            label: "View Coupons",
            icon: Icons.check_circle,
            loading: _submitting,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => CouponListScreen()));
            },
          ),
        ],
      ),
   )
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
