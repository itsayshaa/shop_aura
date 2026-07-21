class ForgotPassword{
  String? id;
  String email;
  String otp;
  String expiresAt;
  String verified;

  ForgotPassword({
    this.id,
    required this.email,
    required this.otp,
    required this.expiresAt,
    required this.verified
  });
  
  Map<String,dynamic> toJson(){
    return {
      "email":email,
      "otp":otp,
      "expiresAt":expiresAt,
      "verified":false
    };
  }
}