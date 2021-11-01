import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/brand.dart';
import 'package:githubit/src/models/brand_category.dart';
import 'package:githubit/src/models/product.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/brand_categories_request.dart';
import 'package:githubit/src/requests/brands_products_request.dart';
import 'package:githubit/src/requests/brands_request.dart';
import 'package:githubit/src/utils/utils.dart';

class BrandsController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  var brandCategoriesList = <BrandCategory>[].obs;
  var homeBrandsList = <Brand>[].obs;
  var allBrands = <Brand>[].obs;
  var brandProductsList = <int, List<Product>>{}.obs;
  var activeBrand = Brand().obs;
  var load = false.obs;

  final LanguageController languageController = Get.put(LanguageController());
  final ProductController productController = Get.put(ProductController());
  Shop? shop;
  ScrollController? scrollController;

  @override
  void onInit() {
    super.onInit();

    scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void onReady() {
    super.onReady();

    getBrandCategories();
  }

  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController!.position.extentAfter < 500) {
      if (brandProductsList[activeBrand.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }

  void getAllBrands() async {
    List<Brand> brands = await getBrands(0, -1, 0);

    allBrands.value = brands;
  }

  Future<List<Brand>> getBrandsList(id) async {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    List<Brand> brandListArray =
        index != -1 ? brandCategoriesList[index].children! : [];

    if (brandListArray.length == 0) {
      brandListArray = await getBrands(id!, -1, 0);
      if (index != -1) brandCategoriesList[index].children = brandListArray;
    }

    int range = brandListArray.length > 3 ? 3 : brandListArray.length;

    if (brandCategoriesList[index].hasLimit!)
      return brandListArray.sublist(0, range);
    else
      return brandListArray;
  }

  void setHasLimit(id) {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    if (index > -1) {
      brandCategoriesList[index].hasLimit =
          !brandCategoriesList[index].hasLimit!;
      brandCategoriesList.refresh();
    }
  }

  bool getHasLimit(id) {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    if (index > -1) {
      return brandCategoriesList[index].hasLimit!;
    }

    return false;
  }

  Future<List<Brand>> getBrands(
      int idBrandCategories, int limit, int offset) async {
    shop = shopController.defaultShop.value;

    List<Brand> brandList = [];

    if (homeBrandsList.length > 0 && idBrandCategories == -1)
      return homeBrandsList;

    Map<String, dynamic> data =
        await brandsRequest(shop!.id!, idBrandCategories, limit, offset);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        brandList.add(Brand(
            id: int.parse(item['id'].toString()),
            name: item['name'],
            imageUrl: item['image_url']));
      }

      if (idBrandCategories == -1) {
        homeBrandsList.value = brandList;
        homeBrandsList.refresh();
      }
    }

    return brandList;
  }

  Future<List<BrandCategory>> getBrandCategories() async {
    shop = shopController.defaultShop.value;
    List<BrandCategory> brandCategoryList = [];

    if (await Utils.checkInternetConnectivity() &&
        shop != null &&
        shop!.id != null &&
        shop!.id! > 0) {
      Map<String, dynamic> data = await brandCategoriesRequest(
          shop!.id!, languageController.activeLanguageId.value);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          brandCategoryList.add(BrandCategory(
              id: int.parse(item['id'].toString()),
              name: item["language"]['name']));
        }

        brandCategoriesList.value = brandCategoryList;
      }
    }

    return brandCategoryList;
  }

  Future<List<Product>> getBrandsProducts(int idBrand, int limit) async {
    List<Product> brandpList =
        brandProductsList[idBrand] != null ? brandProductsList[idBrand]! : [];

    if (load.value) {
      Map<String, dynamic> data = await brandsProductsRequest(
          idBrand,
          languageController.activeLanguageId.value,
          limit,
          brandProductsList[idBrand]!.length,
          productController.searchText.value,
          productController.sortType.value,
          productController.rangeEndPrice.value,
          productController.rangeStartPrice.value,
          productController.filterBrands);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = brandpList.indexWhere((element) => element.id == id);

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
            brandpList.add(Product(
                isCountDown: item['discount'] != null
                    ? int.parse(item['discount']['discount']['is_count_down']
                        .toString())
                    : 0,
                startTime: startTime,
                endTime: endTime,
                id: id,
                name: item['language']['name'],
                amount: int.parse(item['quantity'].toString()),
                description: item['language']['description'],
                images: item['images'],
                unit: item['units'] != null
                    ? item['units']['language']['name']
                    : "",
                rating: int.parse(item['comments_count'].toString()) > 0
                    ? (double.parse(item['comments_sum_star'].toString()) /
                        double.parse(item['comments_count'].toString()))
                    : 5.0,
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
                price: double.parse(item['price'].toString()),
                image: item['images'][0]['image_url']));
        }

        brandProductsList[idBrand] = brandpList;
        brandProductsList.refresh();
        load.value = false;
      }
    }

    return brandpList;
  }
}
