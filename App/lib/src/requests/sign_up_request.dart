import 'dart:convert';
import 'dart:io';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signUpRequest(
    String name,
    String surname,
    String phone,
    String email,
    String password,
    int authType,
    String socialId,
    String pushToken) async {
  String url = "$GLOBAL_URL/client/signup";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "name": name,
    "surname": surname,
    "phone": phone,
    "email": email,
    "auth_type": authType.toString(),
    "password": password,
    "social_id": socialId,
    "device_type": Platform.isAndroid ? "1" : "2",
    "push_token": pushToken
  };

  final client = new http.Client();

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  print(response.body);

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
