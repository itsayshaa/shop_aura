import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

class Jwtservice {
  static final env = DotEnv()..load();
  static final secretKey = env["JWT_SECRET"] ?? "";
  static String generateToken({required String userId, required String email}){
    final jwt = JWT(
      {
        "userId":userId,
        "email":email
      }
    );
    return jwt.sign(
      SecretKey(secretKey),
      expiresIn: Duration(days: 7)
    );
  }

  static Map<String, dynamic>? verifyToken(String token){
    try{
      final jwt = JWT.verify(
        token, 
        SecretKey(secretKey)
        );
        return Map<String,dynamic>.from(jwt.payload);
    }catch(e){
      return null;
    }
  }

  static String? getUserIdFromRequest(dynamic request) {
    try {
      final authHeader = request.headers['Authorization'] ?? request.headers['authorization'];
      if (authHeader == null) return null;
      String token = authHeader;
      if (authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
      }
      final payload = verifyToken(token);
      return payload?['userId']?.toString();
    } catch (e) {
      return null;
    }
  }
}