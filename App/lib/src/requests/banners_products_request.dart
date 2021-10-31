import 'dart:convert';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> bannersProductsRequest(
    int idBanner,
    int idLang,
    int limit,
    int offset,
    String searchText,
    int sortType,
    int maxPrice,
    int minPrice,
    List<int> brandIds) async {
  String url = "$GLOBAL_URL/banner/products";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_lang": idLang.toString(),
    "id_banner": idBanner.toString(),
    "limit": limit.toString(),
    "offset": offset.toString(),
    "search": searchText,
    "sort_type": sortType.toString(),
    "max_price": maxPrice.toString(),
    "min_price": minPrice.toString(),
    "brands": brandIds.join(",")
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};
  print(body);
  print(response.body);

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
