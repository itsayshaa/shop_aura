import './../models/product_model.dart';

class ProductService {
  ProductService._();

  static final ProductService instance = ProductService._();

  final List<ProductModel> _products = [
    ProductModel(
      id: "1",
      name: "Nike Air Max 270",
      brand: "Nike",
      category: "Shoes",
      image:
          "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800",
      price: 4999,
      oldPrice: 6999,
      rating: 4.8,
      reviews: 1254,
      stock: 18,
      discount: 29,
      isFeatured: true,
      isBestSeller: true,
      isFlashSale: true,
    ),
    ProductModel(
      id: "2",
      name: "Apple Watch Series",
      brand: "Apple",
      category: "Electronics",
      image:
          "https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=800",
      price: 32999,
      oldPrice: 37999,
      rating: 4.9,
      reviews: 820,
      stock: 9,
      discount: 15,
      isFeatured: true,
    ),
    ProductModel(
      id: "3",
      name: "Women's Handbag",
      brand: "Zara",
      category: "Fashion",
      image:
          "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800",
      price: 2499,
      oldPrice: 3199,
      rating: 4.7,
      reviews: 540,
      stock: 20,
      discount: 22,
    ),
    ProductModel(
      id: "4",
      name: "Gaming Headset",
      brand: "Logitech",
      category: "Electronics",
      image:
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800",
      price: 3499,
      oldPrice: 4499,
      rating: 4.6,
      reviews: 340,
      stock: 12,
      discount: 20,
      isBestSeller: true,
    ),
    ProductModel(
      id: "5",
      name: "Casual T-Shirt",
      brand: "H&M",
      category: "Fashion",
      image:
          "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800",
      price: 799,
      oldPrice: 1199,
      rating: 4.4,
      reviews: 110,
      stock: 50,
      discount: 33,
    ),
    ProductModel(
      id: "6",
      name: "Wireless Speaker",
      brand: "JBL",
      category: "Electronics",
      image:
          "https://images.unsplash.com/photo-1589003077984-894e133dabab?w=800",
      price: 2799,
      oldPrice: 3499,
      rating: 4.5,
      reviews: 460,
      stock: 16,
      discount: 20,
      isFlashSale: true,
    ),
  ];

  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_products);
  }

  Future<List<ProductModel>> getProductsByCategory(
      String category) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _products
        .where((e) =>
            e.category.toLowerCase() ==
            category.toLowerCase())
        .toList();
  }

  Future<List<ProductModel>> searchProducts(
      String keyword) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _products.where((e) {
      return e.name
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          e.brand
              .toLowerCase()
              .contains(keyword.toLowerCase());
    }).toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _products
        .where((e) => e.isFeatured)
        .toList();
  }

  Future<List<ProductModel>> getFlashSaleProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _products
        .where((e) => e.isFlashSale)
        .toList();
  }

  Future<List<ProductModel>> getBestSellerProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _products
        .where((e) => e.isBestSeller)
        .toList();
  }

  Future<ProductModel?> getProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> refreshProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}