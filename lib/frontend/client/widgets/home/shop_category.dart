import 'package:flutter/material.dart';

class ShopCategory extends StatefulWidget{
  final List<Map<String,dynamic>> categories;

  const ShopCategory({
    super.key,
    required this.categories
  });
  @override
  State<ShopCategory> createState() => _ShopCategory();
}

class _ShopCategory extends State<ShopCategory>{
  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 180,
    child:ListView.builder(
      scrollDirection: Axis.horizontal,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  itemCount: widget.categories.length,

  itemBuilder: (context, index) {
    final category = widget.categories[index];

    return Container(
      width: 130,
      // margin: EdgeInsets.only(right:4),
    child:Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              category["image"] ?? "",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              category["title"] ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  },
    )
);
  }
}