class UserModel{
  String? id;
  String name;
  String email;
  String password;
  List<String> address;
  String phone;
  List<String> wishList;
  String profileImage;
  bool isVerified;
  bool isBlocked;

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
    };
  }

}