import 'dart:convert';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> shopsRequest(int idShopCategory, int idLang,
    int deliveryType, int offset, int limit) async {
  String url = "$GLOBAL_URL/shops/shops";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_shop_categories": idShopCategory.toString(),
    "id_lang": idLang.toString(),
    "delivery_type": deliveryType.toString(),
    "offset": offset.toString(),
    "limit": limit.toString()
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
