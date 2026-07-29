import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_aura/frontend/user/screens/auth/login/login.dart';
import 'package:shop_aura/frontend/user/screens/widgets/profile/edit_details.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';
import 'package:shop_aura/backend/services/authServices.dart';
import 'package:shop_aura/frontend/services/authService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String name = "";
  String email = "";
  String phone = "";
  String createdAt = "";
  String char = "";
  String location = "";
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void _showEditProfilePopup() {
    _nameController.text = name;
    _phoneController.text = phone;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
  bool success = await Authservice.updateProfile(
    name: _nameController.text.trim(),
    phone: _phoneController.text.trim(),
  );

  if (success) {
    setState(() {
      name = _nameController.text.trim();
      phone = _phoneController.text.trim();
      char = name[0].toUpperCase();
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated"),
      ),
    );
  }
},
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

Future<void> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString("user_name") ?? "";
  final userEmail = prefs.getString("user_email") ?? "";
  final userPhone = prefs.getString("user_phone") ?? "";
  final userLocation = prefs.getString("user_location") ?? "";
  if (userName.isEmpty || userEmail.isEmpty || userPhone.isEmpty) {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
    return;
  }

  setState(() {
    name = userName;
    email = userEmail;
    phone = userPhone;
    createdAt = prefs.getString("createdAt") ?? "";
    char = name.isNotEmpty ? name[0].toUpperCase() : "";
    location = userLocation.isEmpty ? "Address is not added" : userLocation;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 3,
                      offset: Offset(1, 0.6),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              char,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 35),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 24),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "My Orders",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.map_outlined, size: 24),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Manage Addresses",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined, size: 24),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Settings",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              await Authservices.logOut(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.danger,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: AppColors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Logout",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 12),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 3,
                      offset: Offset(1, 0.6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),

                      Text(
                        "Profile Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: _showEditProfilePopup,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 37, 36, 36),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 5),
                            Icon(Icons.edit_outlined, size: 24),
                            Text(
                              "Edit profile",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Details(
                        icon: Icons.person_outline,
                        title: "Full Name",
                        data: name,
                      ),
                      Details(
                        icon: Icons.email_outlined,
                        title: "Email Address",
                        data: email,
                      ),
                      Details(
                        icon: Icons.phone_iphone_rounded,
                        title: "Phone Number",
                        data: phone,
                      ),
                      Details(
                        icon: Icons.calendar_today_outlined,
                        title: "joined At",
                        data: createdAt,
                      ),
                      Details(
                        icon: Icons.location_on_outlined,
                        title: "Work Address",
                        data: location,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
