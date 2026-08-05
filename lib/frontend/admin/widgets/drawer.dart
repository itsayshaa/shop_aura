import 'package:flutter/material.dart';
import 'package:shop_aura/backend/services/authServices.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {

static const items = [['Dashboard', Icons.grid_view_rounded],['Products', Icons.inventory_2_outlined],['Categories', Icons.category_outlined],['Orders', Icons.shopping_cart_outlined],['Refunds', Icons.replay_outlined],['Brands', Icons.local_offer_outlined],['Customers', Icons.people_outline_rounded],['Staff', Icons.badge_outlined],['Coupons', Icons.confirmation_number_outlined],['About', Icons.info_outline_rounded],['Contact', Icons.mail_outline_rounded],['Banners', Icons.image_outlined],['Reviews', Icons.star_border_rounded],['Policies', Icons.privacy_tip_outlined],['Settings', Icons.settings_outlined],];


 @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child:SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                "Admin Panel",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 8
                ),
                itemCount: items.length,
                itemBuilder: (context, i){
                  final isSelected = widget.selectedIndex == i;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent: AppColors.transparent,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      leading: Icon(
                        items[i][1] as IconData,
                        size: 20,
                        color: isSelected ? Colors.white :  AppColors.accentHover,
                      ),
                      title: Text(
                        items[i][0] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400
                        ),
                      ),
                      onTap: () {
                        widget.onItemSelected(i);
                        Navigator.pop(context);
                      },
                    ),
                    
                  );  
                },
              ),
            ),
            Divider(height: 1,),
            ListTile(
              leading: Icon(Icons.logout_rounded,color: AppColors.danger,),
              title: Text(
                "LogOut",
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600
                ),
              ),
              onTap: ()async{
                await Authservices.logOut(context);
              },
            ),
            SizedBox(height: 8,)
          ]
        )
        )
    );
  }
}