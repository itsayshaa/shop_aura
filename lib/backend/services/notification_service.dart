import 'email_service.dart';

class NotificationService {
  static Future<void> sendOrderConfirmation({
    required String userEmail,
    required String orderId,
    required double totalAmount,
  }) async {
    print("Notification: Order $orderId created for $userEmail. Total: ₹$totalAmount");
  }

  static Future<void> sendRefundStatusNotification({
    required String orderId,
    required String refundStatus,
    String? userEmail,
  }) async {
    print("Notification: Refund for Order $orderId updated to status: $refundStatus");
    if (userEmail != null && userEmail.isNotEmpty) {
      try {
        // Can integrate EmailService notification here if email is provided
      } catch (e) {
        print("Failed to send refund notification email: $e");
      }
    }
  }

  static Future<void> sendOtpEmail({
    required String email,
    required String otp,
  }) async {
    await EmailService.sendOtp(email: email, otp: otp);
  }
}
