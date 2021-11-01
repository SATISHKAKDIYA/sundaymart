import 'package:get/get.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/banner.dart';
import 'package:githubit/src/models/product.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/banners_products_request.dart';
import 'package:githubit/src/requests/banners_request.dart';

class BannerController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  final LanguageController languageController = Get.put(LanguageController());
  final ProductController productController = Get.put(ProductController());
  var bannerList = <Banner>[].obs;
  var bannerProducts = <Product>[].obs;
  Shop? shop;
  var activeBanner = Banner().obs;
  var load = true.obs;

  List<Product> get bannerProductList => bannerProducts;

  Future<List<Banner>> getBanners() async {
    shop = shopController.defaultShop.value;
    if (bannerList.length > 0) return bannerList;

    List<Banner> banners = [];
    if (load.value && shop!.id != null) {
      Map<String, dynamic> data = await bannersRequest(
          shop!.id!, languageController.activeLanguageId.value);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          banners.add(Banner(
              id: int.parse(item['id'].toString()),
              imageUrl: item['image_url'],
              title: item["language"]['title'],
              subTitle: item["language"]['sub_title'],
              titleColor: item['title_color'],
              backColor: item['background_color'],
              buttonColor: item['button_color'],
              position: int.parse(item['position']),
              buttonText: item["language"]['button_text'],
              buttonTextColor: item['indicator_color'],
              description: item["language"]['description']));
        }
        bannerList.value = banners;
        bannerList.refresh();

        load.value = false;
      }
    }
    return banners;
  }

  Future<List<Product>> getBannerProducts(int id) async {
    if (load.value) {
      Map<String, dynamic> data = await bannersProductsRequest(
          id,
          languageController.activeLanguageId.value,
          10,
          bannerProductList.length,
          productController.searchText.value,
          productController.sortType.value,
          productController.rangeEndPrice.value,
          productController.rangeStartPrice.value,
          productController.filterBrands);

      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];
          int id = int.parse(item['product']['id'].toString());
          int index =
              bannerProductList.indexWhere((element) => element.id == id);

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
            bannerProductList.add(Product(
              startTime: startTime,
              endTime: endTime,
              reviewCount: int.parse(item['comments_count'].toString()),
              isCountDown: item['product']['discount'] != null
                  ? int.parse(item['product']['discount']['discount']
                          ['is_count_down']
                      .toString())
                  : 0,
              name: item['product']['language']['name'],
              image: item['product']['images'][0]['image_url'],
              images: item['product']['images'],
              rating: int.parse(item['comments_count'].toString()) > 0
                  ? (int.parse(item['comments_sum_star'].toString()) /
                      int.parse(item['comments_count'].toString()))
                  : 5.0,
              price: double.parse(item['product']['price'].toString()),
              discount: item['product']['discount'] != null
                  ? double.parse(item['product']['discount']['discount']
                          ['discount_amount']
                      .toString())
                  : 0,
              discountType: item['product']['discount'] != null
                  ? int.parse(item['product']['discount']['discount']
                          ['discount_type']
                      .toString())
                  : 0,
              id: id,
              amount: int.parse(item['product']['quantity'].toString()),
              description: item['product']['language']['description'],
              hasCoupon: item['product']['coupon'] != null,
              unit: item['units'] != null
                  ? item['units']['language']['name']
                  : "",
            ));
        }
      }

      load.value = false;
    }

    return bannerProductList;
  }
}
