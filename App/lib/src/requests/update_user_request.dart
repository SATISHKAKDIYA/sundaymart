import 'dart:convert';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> updateUserRequest(
    int id,
    String name,
    String surname,
    String phone,
    String email,
    String password,
    String image,
    int gender) async {
  String url = "$GLOBAL_URL/client/update";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "id": id.toString(),
    "name": name,
    "surname": surname,
    "phone": phone,
    "email": email,
    "password": password,
    "image_url": image,
    "gender": gender.toString()
  };

  final client = new http.Client();

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};
  print(response.body);

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
