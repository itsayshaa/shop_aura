class ForgotPassword{
  String? id;
  String email;
  String otp;
  DateTime expiresAt;
  bool verified;

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

  factory ForgotPassword.fromJson(
    Map<String,dynamic> json,
  ){
    return ForgotPassword(
      id: json['_id']?.toString(),
      email: json['email'] ?? '',
      otp: json['otp'] ?? '',
      expiresAt: DateTime.parse(
        json['expiresAt'].toString()
      ),
      verified: json['verified'] ?? false
    );
  }
}