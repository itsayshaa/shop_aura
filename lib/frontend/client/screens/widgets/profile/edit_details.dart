import 'package:flutter/material.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class Details extends StatelessWidget{
  final IconData icon;
  final String title;
  final String data;
 Details({
  super.key,
  required this.icon,
  required this.title,
  required this.data
 });

 @override
 Widget build(BuildContext context){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
          Divider(
            thickness: 1.5,
            color: Colors.grey,
            height: 20,
          ),
          SizedBox(height: 10,),
      Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color.fromARGB(255, 113, 113, 113),
            ),
          const SizedBox(width: 5,),
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 113, 113, 113),
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
            ),
        ],
      ),
      SizedBox(height: 10,),
        Text(
          data,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
          ),
    ],
  );
 }
}


