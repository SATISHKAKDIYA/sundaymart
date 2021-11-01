import 'package:get/get.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/address.dart';
import 'package:githubit/src/models/card.dart';
import 'package:githubit/src/models/product.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/requests/order_save_request.dart';

class CartController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  var cartProducts = <Product>[].obs;
  Shop? shop;
  var deliveryType = 1.obs;
  var proccess = 0.obs;
  var proccessPercentage = 0.obs;
  var cardName = "".obs;
  var cardNumber = "".obs;
  var cardExpiredDate = "".obs;
  var cvc = "".obs;
  var orderSent = false.obs;
  var paymentType = 2.obs;
  var paymentStatus = 2.obs;
  var orderComment = "".obs;
  var cards = <Card>[].obs;
  var activeCardNumber = "".obs;
  var isCardAvailable = false.obs;

  @override
  void dispose() {
    super.dispose();
  }

  void addToCart(Product product) {
    product.count = 1;
    int index = cartProducts.indexWhere((element) => element.id == product.id);
    if (index == -1) cartProducts.add(product);
    cartProducts.refresh();
  }

  void increment(id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      cartProducts[index].count = cartProducts[index].count! + 1;
      cartProducts.refresh();
    }
  }

  void decrement(id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      if (cartProducts[index].count! > 1)
        cartProducts[index].count = cartProducts[index].count! - 1;
      else
        cartProducts.removeAt(index);
      cartProducts.refresh();
    }
  }

  int getProductCountById(int id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      if (cartProducts[index].count! == 0) {
        cartProducts.removeAt(index);
        cartProducts.refresh();
        return 0;
      }
      return cartProducts[index].count!;
    }
    return 0;
  }

  void removeProductFromCart(int id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      cartProducts.removeAt(index);
      cartProducts.refresh();
    }
  }

  double calculateAmount() {
    double sum = 0;

    for (Product product in cartProducts) {
      double extrasSum = product.extras != null
          ? product.extras!.fold(0, (a, b) => a + b.price!)
          : 0;
      sum += product.count! * (product.price! + extrasSum);
    }

    return sum;
  }

  double calculateDiscount() {
    double sum = 0;

    for (Product product in cartProducts) {
      double discountPrice = 0;
      if (product.discountType == 1)
        discountPrice = (product.price! * product.discount!) / 100;
      else if (product.discountType == 2)
        discountPrice = product.price! - product.discount!;
      sum += (product.count! * discountPrice);
    }

    return double.parse(sum.toStringAsFixed(2));
  }

  void checkoutData() {
    shop = shopController.defaultShop.value;
    User? user = shopController.authController.getUser();
    Address address = shopController.addressController.getDefaultAddress();

    proccessPercentage.value = 0;
    if (deliveryType.value > 0) proccessPercentage.value += 10;

    if (address.address != null && address.address!.length > 0)
      proccessPercentage.value += 12;

    if (user != null && user.name != null && user.name!.length > 0)
      proccessPercentage.value += 12;

    if (user != null && user.phone != null && user.phone!.length > 0)
      proccessPercentage.value += 12;

    if (proccess.value >= 1) proccessPercentage.value += 4;
  }

  Future<void> orderSave() async {
    orderSent.value = true;
    shop = shopController.defaultShop.value;
    Address address = shopController.addressController.getDefaultAddress();
    User? user = shopController.authController.getUser();

    Map<String, dynamic> body = {
      "total": calculateAmount() -
          calculateDiscount() +
          (shopController.deliveryType.value == 1 ? shop!.deliveryFee! : 0),
      "discount": calculateDiscount(),
      "delivery_date":
          "${shopController.deliveryDate.value} ${shopController.deliveryTimeString.value}",
      "delivery_time_id": shopController.deliveryTime.value.toString(),
      "payment_type": paymentType.value.toString(),
      "payment_status": paymentStatus.value.toString(),
      "products": cartProducts.map((element) => element.toJson()).toList(),
      "address": address.toJson(),
      "user": user!.id.toString(),
      "shop": shop!.id.toString(),
      "comment": orderComment.value.toString(),
      "delivery_type": shopController.deliveryType.value.toString(),
    };

    Map<String, dynamic> data = await orderSaveRequest(body);
    if (data['success']) {
      orderSent.value = false;
      cartProducts.value = [];
      proccess.value = 0;
      Get.back();
    }
  }

  void addToCard() {
    Card card = Card(
      name: cardName.value,
      cardNumber: cardNumber.value,
      expireDate: cardExpiredDate.value,
      cvc: cvc.value,
    );

    int index =
        cards.indexWhere((element) => element.cardNumber == cardNumber.value);
    if (index == -1)
      cards.add(card);
    else
      cards[index] = card;
    cards.refresh();
    Get.back();
  }
}
