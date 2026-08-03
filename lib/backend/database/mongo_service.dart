import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static late Db db;

  static late DbCollection users;
  static late DbCollection password;
  static late DbCollection categories;
  static late DbCollection products;
  static late DbCollection brands;
  static late DbCollection cart;
  static late DbCollection wishlists;
  static late DbCollection orders;
  static late DbCollection refunds;

  static Future<void> connect() async {
    final env = DotEnv()..load();
    final mongoUrl = env['MONGO_URL'];
    if (mongoUrl == null || mongoUrl.isEmpty) {
      throw Exception("MONGO_URL not found in environment variables");
    }

    db = await Db.create(mongoUrl);
    await db.open();

    users = db.collection('users');
    password = db.collection('password');
    categories = db.collection('categories');
    products = db.collection('products');
    cart = db.collection('cart');
    wishlists = db.collection('wishlists');
    orders = db.collection('orders');
    refunds = db.collection('refunds');

    print("MongoDB Atlas Connected via MongoDBService");
  }
}
