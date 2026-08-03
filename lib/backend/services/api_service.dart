import 'dart:convert';
import 'package:shelf/shelf.dart';

class ApiService {
  static Response success({
    required dynamic data,
    String? message,
    int statusCode = 200,
  }) {
    final Map<String, dynamic> body = {
      "success": true,
      if (message != null) "message": message,
    };

    if (data is List) {
      return Response(
        statusCode,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
    } else if (data is Map<String, dynamic>) {
      body.addAll(data);
    } else if (data != null) {
      body["data"] = data;
    }

    return Response(
      statusCode,
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
  }

  static Response error({
    required String message,
    int statusCode = 400,
  }) {
    return Response(
      statusCode,
      body: jsonEncode({
        "success": false,
        "message": message,
      }),
      headers: {"Content-Type": "application/json"},
    );
  }

  static Response unauthorized({String message = "Unauthorized access"}) {
    return error(message: message, statusCode: 401);
  }

  static Response internalError(dynamic e) {
    return error(message: e.toString(), statusCode: 500);
  }
}
