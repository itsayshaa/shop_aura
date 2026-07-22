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
          <body>
            <h2>Shop Aura Password Reset</h2>

            <p>Hello,</p>

            <p>Your password reset OTP is:</p>

            <h1>$otp</h1>

            <p>This OTP is valid for 5 minutes.</p>

            <p>If you did not request this, please ignore this email.</p>

            <br>

            <p>Thanks,<br>Shop Aura Team</p>
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