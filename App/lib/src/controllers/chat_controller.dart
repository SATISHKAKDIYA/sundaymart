import 'package:get/get.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/chat_user.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/shop_user_request.dart';

class ChatController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  var user = Rxn<ChatUser>();

  @override
  void onInit() {
    super.onInit();

    getShopUser();
  }

  Future<void> getShopUser() async {
    Shop? shop = shopController.defaultShop.value;

    if (shop != null && shop.id != null) {
      Map<String, dynamic> data = await shopsUserRequest(shop.id!);

      if (data['success']) {
        user.value = ChatUser(
            id: data['data']['id'],
            name: "${data['data']['name']} ${data['data']['surname']}",
            imageUrl: data['data']['image_url'],
            role: int.parse(data['data']['id_role'].toString()));

        user.refresh();
      }
    }
  }

  void connect() {}
}
