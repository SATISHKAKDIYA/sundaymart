import 'package:get/get.dart';

class Messages extends Translations {
  final Map<String, Map<String, String>> data;

  Messages({required this.data});

  @override
  Map<String, Map<String, String>> get keys => this.data;
}
