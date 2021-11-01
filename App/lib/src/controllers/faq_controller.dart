import 'package:get/get.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/faq.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/faq_request.dart';

class FaqController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  final LanguageController languageController = Get.put(LanguageController());

  Shop? shop;

  Future<List<Faq>> getFaq() async {
    shop = shopController.defaultShop.value;
    List<Faq> faqList = [];
    Map<String, dynamic> data =
        await faqRequest(shop!.id!, languageController.activeLanguageId.value);

    if (data['success']) {
      if (data['data'] != null)
        for (int i = 0; i < data['data'].length; i++) {
          faqList.add(Faq(
              question: data['data'][i]['language']['question'],
              answer: data['data'][i]['language']['answer']));
        }
    }

    return faqList;
  }
}
