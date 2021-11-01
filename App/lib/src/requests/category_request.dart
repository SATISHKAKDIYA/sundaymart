import 'dart:convert';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> categoryRequest(
    int idShop, int idCategory, int idLang, int limit, int offset) async {
  String url = "$GLOBAL_URL/category/categories";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_category": idCategory.toString(),
    "id_lang": idLang.toString(),
    "id_shop": idShop.toString(),
    "limit": limit.toString(),
    "offset": offset.toString()
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  print(body);

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
