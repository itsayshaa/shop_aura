class UserModel{
  String? id;
  String name;
  String email;
  String password;
  List<String> address;
  String phone;
  List<String> wishList;
  String profileImage;
  String createdAt;
  bool isVerified;
  bool isBlocked;
  String role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.wishList,
    required this.profileImage,
    required this.isVerified,
    required this.isBlocked,
    required this.createdAt,
    required this.role
  });

  Map<String,dynamic> toJson(){
    return{
      "name":name,
      "email":email,
      "password":password,
      "address": address,
      "phone":phone,
      "wishList":wishList,
      "profile_image":profileImage,
      "isVerified":isVerified,
      "isBlocked":isBlocked,
      "createdAt":createdAt,
      "role":role
    };
  }

}