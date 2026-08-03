import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'collections.dart';

class MongoDBService {
  static late Db db;

  static late DbCollection users;
  static late DbCollection password;
  static late DbCollection categories;
  static late DbCollection products;
  static late DbCollection brands;
  static late DbCollection carts;
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

    users = db.collection(Collections.users);
    password = db.collection(Collections.password);
    categories = db.collection(Collections.categories);
    products = db.collection(Collections.products);
    carts = db.collection(Collections.carts);
    wishlists = db.collection(Collections.wishlists);
    orders = db.collection(Collections.orders);
    refunds = db.collection(Collections.refunds);

    print("MongoDB Atlas Connected via MongoDBService");
  }

  /// Helper to convert Mongo BSON ObjectId to string safely
  static Map<String, dynamic> cleanDoc(Map<String, dynamic> doc) {
    final copy = Map<String, dynamic>.from(doc);
    if (copy['_id'] != null) {
      copy['_id'] = copy['_id'].toString();
    }
    return copy;
  }

  /// Helper to clean list of BSON documents for JSON response
  static List<Map<String, dynamic>> cleanDocs(List<Map<String, dynamic>> docs) {
    return docs.map((d) => cleanDoc(d)).toList();
  }
}
