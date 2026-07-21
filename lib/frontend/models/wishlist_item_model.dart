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
}