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
  

  static Future<void> connect() async {
    await MongoDBService.connect();
  }
}