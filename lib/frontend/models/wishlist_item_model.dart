class WishlistItem {
  final String image;
  final String category;
  final String name;
  final double rating;
  final int reviews;
  final int price;
  final int oldPrice;
  final int discount;

  WishlistItem({
    required this.image,
    required this.category,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'category': category,
      'name': name,
      'rating': rating,
      'reviews': reviews,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
    };
  }

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      image: json['image'] ?? "",
      category: json['category'] ?? "",
      name: json['name'] ?? "",
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['reviews'] ?? 0,
      price: json['price'] ?? 0,
      oldPrice: json['oldPrice'] ?? 0,
      discount: json['discount'] ?? 0,
    );
  }
}