import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService{
  static late Db db;
  static late DbCollection users;

  static Future<void> connect() async{
    final env = DotEnv()..load();
    final mongoUrl = env["MONGO_URL"];
    if(mongoUrl == null){
      throw Exception('MONGO_URL not found');
    }
    db = await Db.create(mongoUrl);
    await db.open();
    users = db.collection('users');
    print("Mongo Db Connected");
  }
}