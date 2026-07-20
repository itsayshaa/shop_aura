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
    this.quantity = 1,
  });

  /// Returns the total price for this cart item
  int get totalPrice => price * quantity;

  /// Increase quantity by 1
  void increaseQuantity() {
    quantity++;
  }

  /// Decrease quantity by 1 (minimum 1)
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'category': category,
      'name': name,
      'price': price,
      'oldPrice': oldPrice,
      'quantity': quantity,
    };
  }

  /// Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      image: json['image'],
      category: json['category'],
      name: json['name'],
      price: json['price'],
      oldPrice: json['oldPrice'],
      quantity: json['quantity'] ?? 1,
    );
  }

  /// Create a copy with updated values
  CartItem copyWith({
    String? image,
    String? category,
    String? name,
    int? price,
    int? oldPrice,
    int? quantity,
  }) {
    return CartItem(
      image: image ?? this.image,
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}