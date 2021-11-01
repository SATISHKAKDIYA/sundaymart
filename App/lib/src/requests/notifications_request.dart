import 'dart:convert';

import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> notificationsRequest(
    int idShop, int idLang, String date) async {
  String url = "$GLOBAL_URL/notification/notifications";

  DateTime now = DateTime.now();
  int hour = now.hour;
  int minute = now.minute;
  int second = now.second;
  int month = now.month;
  int day = now.day;

  String nowString =
      "${now.year}-${month < 10 ? '0$month' : month}-${day < 10 ? '0$day' : day} ${hour < 10 ? '0$hour' : hour}:${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_lang": idLang.toString(),
    "id_shop": idShop.toString(),
    "date": date,
    "now": nowString
  };

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
