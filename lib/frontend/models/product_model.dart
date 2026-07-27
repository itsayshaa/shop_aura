class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String category;

  final String image;

  final double price;
  final double oldPrice;

  final double rating;
  final int reviews;

  final int stock;

  final int discount;

  final bool isFavorite;
  final bool isFeatured;
  final bool isBestSeller;
  final bool isFlashSale;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.discount,
    this.isFavorite = false,
    this.isFeatured = false,
    this.isBestSeller = false,
    this.isFlashSale = false,
  });

  bool get inStock => stock > 0;

  double get discountPercentage {
    if (oldPrice <= 0) return 0;
    return ((oldPrice - price) / oldPrice) * 100;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    String? image,
    double? price,
    double? oldPrice,
    double? rating,
    int? reviews,
    int? stock,
    int? discount,
    bool? isFavorite,
    bool? isFeatured,
    bool? isBestSeller,
    bool? isFlashSale,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      stock: stock ?? this.stock,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isFlashSale: isFlashSale ?? this.isFlashSale,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      brand: map["brand"] ?? "",
      category: map["category"] ?? "",
      image: map["image"] ?? "",
      price: (map["price"] ?? 0).toDouble(),
      oldPrice: (map["oldPrice"] ?? 0).toDouble(),
      rating: (map["rating"] ?? 0).toDouble(),
      reviews: map["reviews"] ?? 0,
      stock: map["stock"] ?? 0,
      discount: map["discount"] ?? 0,
      isFavorite: map["isFavorite"] ?? false,
      isFeatured: map["isFeatured"] ?? false,
      isBestSeller: map["isBestSeller"] ?? false,
      isFlashSale: map["isFlashSale"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "category": category,
      "image": image,
      "price": price,
      "oldPrice": oldPrice,
      "rating": rating,
      "reviews": reviews,
      "stock": stock,
      "discount": discount,
      "isFavorite": isFavorite,
      "isFeatured": isFeatured,
      "isBestSeller": isBestSeller,
      "isFlashSale": isFlashSale,
    };
  }
}