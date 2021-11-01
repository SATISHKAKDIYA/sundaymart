import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/currency_controller.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/category.dart';
import 'package:githubit/src/models/product.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/category_product_request.dart';
import 'package:githubit/src/requests/category_request.dart';
import 'package:githubit/src/utils/utils.dart';

class CategoryController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  final CurrencyController currencyController = Get.put(CurrencyController());
  final LanguageController languageController = Get.put(LanguageController());
  final ProductController productController = Get.put(ProductController());
  var categoryList = <Category>[].obs;
  var tabIndex = 0.obs;
  List<String> tabs = ["All".tr, "New".tr, "Recommended".tr, "Popular".tr];
  var homeCategoryProductList = <int, List<Product>>{}.obs;
  var categoryProductList = <int, List<Product>>{}.obs;
  Shop? shop;
  ScrollController? scrollController;
  ScrollController? subScrollController;
  var activeCategory = Category().obs;
  var inActiveCategory = Category().obs;
  var load = false.obs;
  var typing = false.obs;

  @override
  void onInit() {
    super.onInit();

    scrollController = new ScrollController()..addListener(_scrollListener);
    subScrollController = new ScrollController()
      ..addListener(_subScrollListener);

    shop = shopController.defaultShop.value;
    if (shop != null && shop!.id != null && categoryList.length == 0) {
      getCategories(-1, 10, 0);
    }
  }

  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    subScrollController!.removeListener(_subScrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController!.position.extentAfter < 500) {
      if (categoryProductList[activeCategory.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }

  void _subScrollListener() {
    if (subScrollController!.position.extentAfter < 500) {
      if (categoryProductList[activeCategory.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }

  Future<List<Category>> getCategories(
      int idCategory, int limit, int offset) async {
    shop = shopController.defaultShop.value;

    List<Category> categories = [];
    if (await Utils.checkInternetConnectivity() && shop != null) {
      Map<String, dynamic> data = await categoryRequest(shop!.id!, idCategory,
          languageController.activeLanguageId.value, limit, offset);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = categories.indexWhere((element) => element.id == id);

          if (index == -1)
            categories.add(Category(
                id: id,
                name: item["language"]['name'],
                imageUrl: item['image_url']));
        }

        if (idCategory == -1) {
          categoryList.value = categories;
          categoryList.refresh();
        }
      }
    }

    return categories;
  }

  Future<List<Product>> getCategoryProducts(int idCategory, bool isMain) async {
    List<Product> productList = [];
    int offset = 0;

    if (!isMain && categoryProductList[idCategory] != null) {
      productList = categoryProductList[idCategory]!;
      offset = categoryProductList[idCategory]!.length;
    }

    if (homeCategoryProductList[idCategory] != null &&
        homeCategoryProductList[idCategory]!.length > 0 &&
        isMain) return homeCategoryProductList[idCategory]!;

    if (offset == 0 && isMain) load.value = true;

    if (load.value) {
      Map<String, dynamic> data = await categoryProductsRequest(
          idCategory,
          languageController.activeLanguageId.value,
          10,
          offset,
          isMain ? tabIndex.value : 0,
          productController.searchText.value,
          productController.sortType.value,
          productController.rangeEndPrice.value,
          productController.rangeStartPrice.value,
          productController.filterBrands);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = productList.indexWhere((element) => element.id == id);

          int startTime =
              item['discount'] != null && item['discount']['discount'] != null
                  ? DateTime.parse(item['discount']['discount']['start_time'])
                      .toUtc()
                      .millisecondsSinceEpoch
                  : 0;
          int endTime =
              item['discount'] != null && item['discount']['discount'] != null
                  ? DateTime.parse(item['discount']['discount']['end_time'])
                      .toUtc()
                      .millisecondsSinceEpoch
                  : 0;

          if (index == -1)
            productList.add(Product(
                isCountDown: item['discount'] != null
                    ? int.parse(item['discount']['discount']['is_count_down']
                        .toString())
                    : 0,
                name: item['language']['name'],
                description: item['language']['description'],
                amount: int.parse(item['quantity'].toString()),
                image: item['images'][0]['image_url'],
                images: item['images'],
                startTime: startTime,
                endTime: endTime,
                unit: item['units'] != null
                    ? item['units']['language']['name']
                    : "",
                rating: int.parse(item['comments_count'].toString()) > 0
                    ? (int.parse(item['comments_sum_star'].toString()) /
                        int.parse(item['comments_count'].toString()))
                    : 5.0,
                price: double.parse(item['price'].toString()),
                discount: item['discount'] != null
                    ? double.parse(item['discount']['discount']
                            ['discount_amount']
                        .toString())
                    : 0,
                discountType: item['discount'] != null
                    ? int.parse(item['discount']['discount']['discount_type']
                        .toString())
                    : 0,
                hasCoupon: item['coupon'] != null,
                reviewCount: int.parse(item['comments_count'].toString()),
                id: id));
        }

        if (isMain) {
          homeCategoryProductList[idCategory] = productList;
          homeCategoryProductList.refresh();
        } else {
          categoryProductList[idCategory] = productList;
          categoryProductList.refresh();
        }
      }

      load.value = false;
    }

    return productList;
  }

  void onChangeProductType(index) {
    tabIndex.value = index;

    categoryList.value = [];
    refresh();

    getCategories(-1, 10, 0);

    homeCategoryProductList.value = {};
    homeCategoryProductList.refresh();
  }
}
