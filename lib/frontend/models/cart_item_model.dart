class CartItem {
  final String image;
  final String category;
  final String name;
  final int price;
  final int oldPrice;
  int quantity;

  CartItem({
    required this.image,
    required this.category,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'image': image,
        'category': category,
        'name': name,
        'price': price,
        'oldPrice': oldPrice,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        image: json['image'] as String,
        category: json['category'] as String,
        name: json['name'] as String,
        price: json['price'] as int,
        oldPrice: json['oldPrice'] as int,
        quantity: json['quantity'] as int,
      );
}