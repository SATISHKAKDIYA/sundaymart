import 'dart:convert';

import 'dart:io';
import 'package:githubit/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> imageUploadRequest(File file) async {
  String url = "$GLOBAL_URL/upload";

  var request = http.MultipartRequest("POST", Uri.parse(url));
  var pic = await http.MultipartFile.fromPath("file", file.path);
  request.files.add(pic);
  var response = await request.send();
  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      responseJson = json.decode(responseString) as Map<String, dynamic>;
    }
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
