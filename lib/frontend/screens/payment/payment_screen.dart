import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/services/cart_service.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

import 'package:shop_aura/frontend/screens/payment/payment_types.dart';
import 'package:shop_aura/frontend/screens/widgets/order_summary_section.dart';
import 'package:shop_aura/frontend/screens/widgets/delivery_address_section.dart';
import 'package:shop_aura/frontend/screens/widgets/delivery_options_section.dart';
import 'package:shop_aura/frontend/screens/widgets/payment_methods_section.dart';
import 'package:shop_aura/frontend/screens/widgets/card_details_form.dart';
import 'package:shop_aura/frontend/screens/widgets/upi_payment_section.dart';
import 'package:shop_aura/frontend/screens/widgets/place_order_bar.dart';
import 'package:shop_aura/frontend/screens/widgets/loading_state.dart';
import 'package:shop_aura/frontend/screens/widgets/failure_screen.dart';
import 'package:shop_aura/frontend/screens/widgets/success_screen.dart';
import 'package:shop_aura/frontend/screens/widgets/section_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentStep = 0; // 0: Summary, 1: Address, 2: Payment

  // ---- Delivery Options ----
  int _deliveryOptionIndex = 0;

  // ---- Address Form ----
  final _addressFormKey = GlobalKey<FormState>();
  final _addressNameCtrl = TextEditingController();
  final _addressPhoneCtrl = TextEditingController();
  final _addressStreetCtrl = TextEditingController();
  final _addressCityCtrl = TextEditingController();
  final _addressZipCtrl = TextEditingController();
  final _addressStateCtrl = TextEditingController();

  // ---- Payment Method ----
  PaymentMethod _selectedMethod = PaymentMethod.card;

  // ---- Card details ----
  final _cardFormKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _cardExpiryCtrl = TextEditingController();
  final _cardCvvCtrl = TextEditingController();

  // ---- UPI ----
  final _upiCtrl = TextEditingController();

  // ---- Promo & Wallet ----
  final _promoCtrl = TextEditingController();
  bool _promoApplied = false;
  bool _useWallet = false;
  final double _walletBalance = 250.0;

  // ---- Terms ----
  bool _acceptedTerms = false;

  // ---- Placing Order ----
  bool _isPlacingOrder = false;

  static const double _deliveryFeeStandard = 0;
  static const double _deliveryFeeExpress = 99;

  double get _deliveryFee =>
      _deliveryOptionIndex == 0 ? _deliveryFeeStandard : _deliveryFeeExpress;

  double get _walletDiscount =>
      _useWallet ? _walletBalance.clamp(0, _rawTotal) : 0;

  double get _rawTotal => CartService.instance.totalPrice + _deliveryFee;

  double get _finalTotal => (_rawTotal - _walletDiscount).clamp(0, double.infinity);

  @override
  void dispose() {
    _addressNameCtrl.dispose();
    _addressPhoneCtrl.dispose();
    _addressStreetCtrl.dispose();
    _addressCityCtrl.dispose();
    _addressZipCtrl.dispose();
    _addressStateCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose();
    _upiCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    if (_promoCtrl.text.trim().isEmpty) return;
    setState(() => _promoApplied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Promo code applied successfully!")),
    );
  }

  bool _validatePaymentDetails() {
    switch (_selectedMethod) {
      case PaymentMethod.card:
        return _cardFormKey.currentState?.validate() ?? false;
      case PaymentMethod.upi:
        if (_upiCtrl.text.trim().isEmpty || !_upiCtrl.text.contains('@')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a valid UPI ID (e.g. mobile@upi)")),
          );
          return false;
        }
        return true;
      case PaymentMethod.wallet:
      case PaymentMethod.cod:
        return true;
    }
  }

  Future<void> _placeOrder() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept the Terms & Policies to continue")),
      );
      return;
    }

    if (!_validatePaymentDetails()) return;

    setState(() => _isPlacingOrder = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      
      final double totalPaid = _finalTotal;
      
      // Clear cart on successful order
      CartService.instance.clearCart();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            total: totalPaid,
            onDone: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FailureScreen(
            reason: "We couldn't process your payment. Please check your details and try again.",
            onRetry: () => Navigator.pop(context),
            onCancel: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  void _onNext() {
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_addressFormKey.currentState?.validate() ?? false) {
        setState(() => _currentStep = 2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required address fields")),
        );
      }
    } else if (_currentStep == 2) {
      _placeOrder();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlacingOrder) return const LoadingState();

    final cart = CartService.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.primary,
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBack,
        ),
      ),
      body: Column(
        children: [
          // Step progress indicator
          _buildStepperHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: _buildStepContent(cart),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PlaceOrderBar(
        total: _finalTotal,
        buttonText: _currentStep == 2 ? "Place Order" : "Continue",
        onPressed: _onNext,
        onBackPressed: _currentStep > 0 ? _onBack : null,
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepIndicator(0, "Summary"),
          _buildStepLine(0),
          _buildStepIndicator(1, "Address"),
          _buildStepLine(1),
          _buildStepIndicator(2, "Payment"),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String label) {
    final bool isCompleted = _currentStep > stepIndex;
    final bool isActive = _currentStep == stepIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.success
                : isActive
                    ? AppColors.primary
                    : AppColors.background,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    "${stepIndex + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppColors.textSoft,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isActive || isCompleted ? AppColors.text : AppColors.textSoft,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int afterStep) {
    final bool isPassed = _currentStep > afterStep;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 2,
          color: isPassed ? AppColors.success : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildStepContent(CartService cart) {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            SectionCard(
              title: "Order Summary",
              icon: Icons.receipt_long_outlined,
              child: OrderSummarySection(cart: cart),
            ),
            const SizedBox(height: 14),
            SectionCard(
              title: "Delivery Speed",
              icon: Icons.local_shipping_outlined,
              child: DeliveryOptionsSection(
                selectedIndex: _deliveryOptionIndex,
                onChanged: (i) => setState(() => _deliveryOptionIndex = i),
              ),
            ),
            const SizedBox(height: 14),
            _buildPriceDetailsSection(cart),
          ],
        );
      case 1:
        return Form(
          key: _addressFormKey,
          child: Column(
            children: [
              SectionCard(
                title: "Delivery Address",
                icon: Icons.location_on_outlined,
                child: DeliveryAddressSection(
                  nameCtrl: _addressNameCtrl,
                  phoneCtrl: _addressPhoneCtrl,
                  streetCtrl: _addressStreetCtrl,
                  cityCtrl: _addressCityCtrl,
                  zipCtrl: _addressZipCtrl,
                  stateCtrl: _addressStateCtrl,
                ),
              ),
            ],
          ),
        );
      case 2:
        return Column(
          children: [
            SectionCard(
              title: "Payment Method",
              icon: Icons.payment_outlined,
              child: Column(
                children: [
                  PaymentMethodsSection(
                    selected: _selectedMethod,
                    onChanged: (m) => setState(() => _selectedMethod = m),
                  ),
                  if (_selectedMethod == PaymentMethod.card)
                    Form(
                      key: _cardFormKey,
                      child: CardDetailsForm(
                        numberCtrl: _cardNumberCtrl,
                        nameCtrl: _cardNameCtrl,
                        expiryCtrl: _cardExpiryCtrl,
                        cvvCtrl: _cardCvvCtrl,
                      ),
                    ),
                  if (_selectedMethod == PaymentMethod.upi)
                    UpiPaymentSection(upiCtrl: _upiCtrl),
                  if (_selectedMethod == PaymentMethod.wallet)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Wallet balance: ₹$_walletBalance will be used at checkout.",
                        style: const TextStyle(color: AppColors.textSoft, fontSize: 13),
                      ),
                    ),
                  if (_selectedMethod == PaymentMethod.cod)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        "Pay with cash when your order is delivered.",
                        style: TextStyle(color: AppColors.textSoft, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _buildPromoWalletSection(),
            const SizedBox(height: 14),
            _buildPriceDetailsSection(cart),
            const SizedBox(height: 14),
            _buildTermsSection(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPromoWalletSection() {
    return SectionCard(
      title: "Promo & Wallet",
      icon: Icons.card_giftcard_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter Promo Code",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyPromo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Apply"),
              ),
            ],
          ),
          if (_promoApplied) ...[
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.check_circle, color: AppColors.success, size: 16),
                SizedBox(width: 4),
                Text("Promo applied: 10% discount", style: TextStyle(color: AppColors.success, fontSize: 12)),
              ],
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Use Wallet Balance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("Available balance: ₹$_walletBalance", style: const TextStyle(color: AppColors.textSoft, fontSize: 12)),
                ],
              ),
              Switch(
                value: _useWallet,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _useWallet = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsSection(CartService cart) {
    return SectionCard(
      title: "Price Details",
      icon: Icons.request_quote_outlined,
      child: Column(
        children: [
          SummaryRow(label: "Subtotal", value: "₹${cart.totalPrice}"),
          SummaryRow(
            label: _deliveryOptionIndex == 0 ? "Delivery (Standard)" : "Delivery (Express)",
            value: _deliveryFee == 0 ? "Free" : "₹${_deliveryFee.toStringAsFixed(2)}",
          ),
          if (_useWallet)
            SummaryRow(
              label: "Wallet applied",
              value: "-₹${_walletDiscount.toStringAsFixed(2)}",
              valueColor: AppColors.success,
            ),
          const Divider(height: 20, color: AppColors.border),
          SummaryRow(
            label: "Total Amount",
            value: "₹${_finalTotal.toStringAsFixed(2)}",
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Row(
      children: [
        Checkbox(
          value: _acceptedTerms,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
        ),
        const Expanded(
          child: Text(
            "I agree to the Terms, Refund and Privacy policies.",
            style: TextStyle(fontSize: 13, color: AppColors.textSoft),
          ),
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 15 : 13.5,
      color: AppColors.text,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style.copyWith(
              color: valueColor ?? (bold ? AppColors.text : AppColors.textSoft),
            ),
          ),
        ],
      ),
    );
  }
}