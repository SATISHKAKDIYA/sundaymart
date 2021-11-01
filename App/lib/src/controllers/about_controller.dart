import 'package:get/get.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/about_request.dart';

class AboutControler extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  final LanguageController languageController = Get.put(LanguageController());

  Shop? shop;

  Future<String> getAboutContent() async {
    shop = shopController.defaultShop.value;
    Map<String, dynamic> data = await aboutRequest(
        shop!.id!, languageController.activeLanguageId.value);

    if (data['success']) {
      if (data['data'] != null && data['data']['language'] != null)
        return data['data']['language']['content'];
    }

    return "";
  }
}
