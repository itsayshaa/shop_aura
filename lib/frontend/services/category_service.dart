import '/frontend/models/category_model.dart';

class CategoryService {
  CategoryService._();

  static final CategoryService instance = CategoryService._();

  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      CategoryModel(
        id: "1",
        name: "Fashion",
        image:
            "https://images.unsplash.com/photo-1441986300917-64674bd600d8",
        icon: "assets/icons/fashion.png",
        description: "Latest Fashion Collection",
        productCount: 2450,
        isFeatured: true,
        brands: [
          "Nike",
          "Adidas",
          "Puma",
          "Zara",
          "H&M",
        ],
      ),

      CategoryModel(
        id: "2",
        name: "Mobiles",
        image:
            "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
        icon: "assets/icons/mobile.png",
        description: "Latest Smartphones",
        productCount: 980,
        isFeatured: true,
        brands: [
          "Apple",
          "Samsung",
          "OnePlus",
          "Xiaomi",
        ],
      ),

      CategoryModel(
        id: "3",
        name: "Electronics",
        image:
            "https://images.unsplash.com/photo-1498049794561-7780e7231661",
        icon: "assets/icons/electronics.png",
        description: "Electronic Devices",
        productCount: 1200,
        isFeatured: true,
        brands: [
          "Sony",
          "LG",
          "Dell",
          "HP",
        ],
      ),

      CategoryModel(
        id: "4",
        name: "Beauty",
        image:
            "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9",
        icon: "assets/icons/beauty.png",
        description: "Beauty Essentials",
        productCount: 560,
        isFeatured: false,
        brands: [
          "Lakme",
          "Maybelline",
          "Loreal",
        ],
      ),

      CategoryModel(
        id: "5",
        name: "Furniture",
        image:
            "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
        icon: "assets/icons/furniture.png",
        description: "Home Furniture",
        productCount: 720,
        isFeatured: true,
        brands: [
          "IKEA",
          "Nilkamal",
          "Godrej",
        ],
      ),

      CategoryModel(
        id: "6",
        name: "Groceries",
        image:
            "https://images.unsplash.com/photo-1542838132-92c53300491e",
        icon: "assets/icons/grocery.png",
        description: "Daily Essentials",
        productCount: 3400,
        isFeatured: false,
        brands: [
          "Nestle",
          "Amul",
          "Aashirvaad",
        ],
      ),

      CategoryModel(
        id: "7",
        name: "Sports",
        image:
            "https://images.unsplash.com/photo-1517649763962-0c623066013b",
        icon: "assets/icons/sports.png",
        description: "Sports Collection",
        productCount: 460,
        isFeatured: false,
        brands: [
          "Yonex",
          "Nivia",
          "Cosco",
        ],
      ),

      CategoryModel(
        id: "8",
        name: "Books",
        image:
            "https://images.unsplash.com/photo-1512820790803-83ca734da794",
        icon: "assets/icons/books.png",
        description: "Books & Novels",
        productCount: 650,
        isFeatured: false,
        brands: [
          "Penguin",
          "Oxford",
        ],
      ),
    ];
  }

  Future<List<CategoryModel>> getFeaturedCategories() async {
    final data = await getCategories();

    return data.where((e) => e.isFeatured).toList();
  }

  Future<List<CategoryModel>> searchCategories(String keyword) async {
    final data = await getCategories();

    if (keyword.trim().isEmpty) {
      return data;
    }

    return data.where((category) {
      return category.name
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          category.description
              .toLowerCase()
              .contains(keyword.toLowerCase());
    }).toList();
  }

  Future<List<String>> getPopularBrands() async {
    final categories = await getCategories();

    final brands = <String>{};

    for (final item in categories) {
      brands.addAll(item.brands);
    }

    return brands.toList()..sort();
  }

  Future<void> refreshCategories() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}