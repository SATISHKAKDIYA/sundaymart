import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/controllers/cart_controller.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/models/brand.dart';
import 'package:githubit/src/models/extra.dart';
import 'package:githubit/src/models/product.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/requests/product_comment_request.dart';
import 'package:githubit/src/requests/product_extras_request.dart';

class ProductController extends GetxController {
  var likedProducts = <Product>[].obs;
  final CartController cartController = Get.put(CartController());
  final LanguageController languageController = Get.put(LanguageController());
  var selectedIndex = 0.obs;
  var rangeStartPrice = 0.obs;
  var rangeEndPrice = 10000.obs;
  var sortType = 0.obs;
  var searchText = "".obs;
  var activeProduct = Product().obs;
  var productCommentStar = 5.obs;
  var productCommentText = "".obs;
  Timer? searchOnStoppedTyping;
  var filterBrands = <int>[].obs;

  double getDiscountPrice(double discount, double price, int discountType) {
    double discountPrice = 0;

    if (discount <= 0) return price;

    if (discountType == 1)
      discountPrice = price - price * (discount / 100);
    else if (discountType == 2) discountPrice = price - discount;

    return double.parse(discountPrice.toStringAsFixed(2));
  }

  String getDiscount(double discount, int discountType) {
    return discountType == 1 ? "$discount %" : "$discount";
  }

  String getDiscountAmount(double discount, double price, int discountType) {
    double discountPrice = 0;

    if (discountType == 1)
      discountPrice = price * (discount / 100);
    else
      discountPrice = discount;
    return discountPrice.toStringAsFixed(2);
  }

  void addToLiked(Product product) {
    int index = likedProducts.indexWhere((element) => element.id == product.id);
    if (index == -1)
      likedProducts.add(product);
    else
      likedProducts.removeAt(index);

    likedProducts.refresh();
  }

  bool isLiked(int id) {
    int index = likedProducts.indexWhere((element) => element.id == id);
    if (index == -1) return false;
    return true;
  }

  Future<Map<String, dynamic>> getExtras(idProduct) async {
    Map<String, dynamic> data = await productExtrasRequest(
        idProduct, languageController.activeLanguageId.value);
    if (data['success']) {
      int commentCount = int.parse(data['data']['comments_count'].toString());
      activeProduct.value.reviewCount = commentCount;

      return data['data'];
    }

    return {};
  }

  Future<void> saveComment() async {
    final box = GetStorage();
    var userJson = box.read('user') ?? null;

    User? user = userJson != null ? User.fromJson(userJson) : null;

    Map<String, dynamic> data = await productCommentRequest(
        user!.id!,
        activeProduct.value.id!,
        productCommentStar.value,
        productCommentText.value);

    if (data['success']) {
      productCommentText.value = "";
      productCommentStar.value = 5;

      activeProduct.value.reviewCount =
          int.parse(data['data']['comments_count'].toString());
      activeProduct.value.rating =
          double.parse(data['data']['comments_sum_star'].toString()) /
              double.parse(data['data']['comments_count'].toString());

      Get.back();
    }
  }

  void clearFilter() {
    rangeStartPrice.value = 0;
    rangeEndPrice.value = 10000;
    sortType.value = 0;
    searchText.value = "";
  }

  void setFilterBrands(int id) {
    int index = filterBrands.indexWhere((element) => element == id);
    if (index == -1)
      filterBrands.add(id);
    else
      filterBrands.removeAt(index);

    filterBrands.refresh();
  }

  bool inFilterBrands(int id) {
    int index = filterBrands.indexWhere((element) => element == id);

    return index != -1;
  }

  List<Brand> allBrands() {
    BrandsController brandsController = Get.put(BrandsController());
    return brandsController.allBrands;
  }

  void addToExtras(int id, String name, int type, double price) {
    Extra extra = Extra(id: id, name: name, type: type, price: price);
    if (activeProduct.value.extras != null) {
      int index = activeProduct.value.extras!
          .indexWhere((element) => element.type == type);

      if (index == -1)
        activeProduct.value.extras!.add(extra);
      else {
        int indexn = activeProduct.value.extras!
            .indexWhere((element) => element.id == id);

        activeProduct.value.extras!.removeAt(index);
        if (indexn == -1) activeProduct.value.extras!.add(extra);
      }
    } else {
      activeProduct.value.extras = [];
      activeProduct.value.extras!.add(extra);
    }

    activeProduct.refresh();
  }
}
