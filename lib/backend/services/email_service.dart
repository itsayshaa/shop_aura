import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:dotenv/dotenv.dart';

class EmailService {
  static Future<void> sendOtp({
    required String email,
    required String otp,
  }) async {
final env = DotEnv()..load();
final user = env["GMAIL_USER"]?? "";
final password = env["GMAIL_PASSWORD"] ?? "";
print(user);
if(user.isEmpty || password.isEmpty){
  throw Exception('Gmail credentials are missing');
}
    final smtpServer = gmail(
      user,
      password
    );

    final message = Message()
      ..from = Address(
        'rihaalcp@gmail.com',
        'Shop Aura',
      )
      ..recipients.add(email)
      ..subject = 'Shop Aura - Password Reset OTP'
      ..html = '''
       <!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
</head>

<body style="margin:0; padding:0; background:#f5f5f5; font-family:Arial,sans-serif;">

  <div style="max-width:600px; margin:40px auto; background:#ffffff;
              border-radius:16px; overflow:hidden;">

    <!-- Header -->
    <div style="background:#F7F3EE; padding:30px; text-align:center;">
      <h1 style="color:white; margin:0;">ShopAura</h1>
      <p style="color:#eeeeee; margin-top:8px;">
        Password Reset
      </p>
    </div>

    <!-- Content -->
    <div style="padding:40px;">

      <h2 style="color:#1E1E2D;">
        Reset Your Password
      </h2>

      <p style="color:#666666; font-size:16px;">
        We received a request to reset your ShopAura password.
        Use the OTP below to continue.
      </p>

      <!-- OTP -->
      <div style="margin:30px 0; padding:20px;
                  background:#f4f3ff;
                  border-radius:12px;
                  text-align:center;">

        <p style="margin:0; color:#777777;">
          Your OTP
        </p>

        <h1 style="margin:10px 0; color:#6C63FF;
                   letter-spacing:8px;">
          $otp
        </h1>

      </div>

      <p style="color:#777777;">
        This OTP will expire in <strong>5 minutes</strong>.
      </p>

      <p style="color:#777777;">
        If you did not request a password reset, you can safely
        ignore this email.
      </p>

    </div>

    <!-- Footer -->
    <div style="background:#f8f9fd; padding:20px; text-align:center;">
      <p style="margin:0; color:#999999; font-size:13px;">
        © 2026 ShopAura. All rights reserved.
      </p>
    </div>

  </div>

</body>
</html>
      ''';

    try {
      final sendReport = await send(message, smtpServer);

      print("OTP Email send successfully to $email");
    } on MailerException catch (e) {
      print('Failed to send email: $e');
      throw Exception('Failed to send OTP email');
    }
  }
}