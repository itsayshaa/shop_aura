import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'mongodb_service.dart';

class MongoService {
  static Db get db => MongoDBService.db;

  static DbCollection get users => MongoDBService.users;
  static DbCollection get password => MongoDBService.password;
  static DbCollection get categories => MongoDBService.categories;
  static DbCollection get products => MongoDBService.products;
  static DbCollection get carts => MongoDBService.carts;
  static DbCollection get wishlists => MongoDBService.wishlists;
  static DbCollection get orders => MongoDBService.orders;
  

<<<<<<< HEAD
  static late DbCollection users;
  static late DbCollection password;
  static late DbCollection categories;
  static late DbCollection products;
  static late DbCollection brands;
  static late DbCollection carts;
  static late DbCollection wishlists;
  static late DbCollection orders;
  static Future<void> connect() async {
    final env = DotEnv()..load();
    final mongoUrl = env['MONGO_URL'];
    if (mongoUrl == null) {
      throw Exception("MONGO_URL not found");
    }
    db = await Db.create(mongoUrl);
    await db.open();
    users = db.collection('users');
    password = db.collection('password');
    categories = db.collection('categories');
    products = db.collection('products');
    brands = db.collection('brands');
    carts = db.collection('carts');
    wishlists = db.collection('wishlists');
    orders = db.collection('orders');
    print("Mongo Db Connected");
=======
  static Future<void> connect() async {
    await MongoDBService.connect();
>>>>>>> ae5a1ca53de7f980eb2f499e6f7c696bf4a3304e
  }
}