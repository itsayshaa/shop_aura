class CustomerModel {
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String? email;

  CustomerModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'phone': phone,
        'address': address,
        'email': email,
      };

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      email: json['email'],
    );
  }
}
