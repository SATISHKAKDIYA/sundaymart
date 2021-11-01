import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/controllers/address_controller.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/controllers/banner_controller.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/controllers/cart_controller.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/controllers/chat_controller.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/notification_controller.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/models/time_unit.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/requests/shop_categories_request.dart';
import 'package:githubit/src/requests/shop_timeunits.dart';
import 'package:githubit/src/requests/shops_request.dart';
import 'package:githubit/src/utils/utils.dart';

class ShopController extends GetxController with SingleGetTickerProviderMixin {
  final AuthController authController = Get.put(AuthController());
  final AddressController addressController = Get.put(AddressController());
  final LanguageController languageController = Get.put(LanguageController());
  TabController? tabController;
  var user = Rxn<User>();

  var deliveryType = 1.obs;
  var categoryList = [].obs;
  var shopList = [].obs;
  var savedShopList = RxList<Shop>();
  var shopCategory = (-1).obs;
  var shopTimeUnitsList = <TimeUnit>[].obs;
  var offset = 0.obs;
  var deliveryDate = "".obs;
  var deliveryTime = 0.obs;
  var deliveryDateString = "".obs;
  var deliveryTimeString = "".obs;
  var loading = false.obs;
  var defaultShop = Rxn<Shop>();

  @override
  void onInit() {
    super.onInit();

    tabController = new TabController(length: 2, vsync: this);
    user.value = authController.getUser();

    this.getSavedShopList();
    this.getShopCategories();
    this.getShops();
  }

  List<Shop> get shops => this.savedShopList;

  void getSavedShopList() {
    final box = GetStorage();
    List<dynamic> data = box.read("shops") ?? [];

    savedShopList.value =
        data.map<Shop>((item) => Shop.fromJson(item)).toList();
    savedShopList.refresh();

    if (shopTimeUnitsList.length == 0) {
      int indexDefault =
          savedShopList.indexWhere((item) => item.isDefault == true);
      if (indexDefault > -1) {
        getTimeUnits(savedShopList[indexDefault].id!);
      }
    }
  }

  Future<void> getShops() async {
    user.value = authController.getUser();

    if (await Utils.checkInternetConnectivity()) {
      Map<String, dynamic> data = await shopsRequest(
          shopCategory.value,
          languageController.activeLanguageId.value,
          deliveryType.value,
          offset.value,
          10);

      if (data['success']) {
        shopList.value = data['data'];
        shopList.refresh();
        loading.value = false;

        for (int i = 0; i < savedShopList.length; i++) {
          int index = shopList.indexWhere((element) =>
              element['id'] == savedShopList[i].id &&
              element['language']['name'] == savedShopList[i].name);
          if (index == -1) {
            savedShopList.removeAt(i);
            savedShopList.refresh();
          }
        }
      }
    }
  }

  Future<void> getShopCategories() async {
    if (await Utils.checkInternetConnectivity()) {
      Map<String, dynamic> data = await shopCategoriesRequest(
          languageController.activeLanguageId.value);
      if (data['success']) {
        categoryList.value = data['data'];
      }
    }
  }

  void onChangeDeliveryType(deliveryTypeId) {
    deliveryType.value = deliveryTypeId;
    shopList.value = [];
    loading.value = true;

    getShops();
  }

  void onChangeShopCategory(shopCategoryId) {
    shopCategory.value = shopCategoryId;
    shopList.value = [];
    loading.value = true;

    getShops();
  }

  void addToSavedShop(Map<String, dynamic> shopData) {
    List<Shop> shops = savedShopList;

    int indexDefault = shops.indexWhere((item) => item.isDefault == true);
    if (indexDefault > -1) {
      shops[indexDefault].isDefault = false;
    }

    Shop shop = Shop(
        isDefault: true,
        name: shopData['language']['name'],
        description: shopData['language']['description'],
        logoUrl: shopData['logo_url'],
        id: shopData['id'],
        backImageUrl: shopData['backimage_url'],
        info: shopData['language']['info'],
        address: shopData['language']['address'],
        deliveryFee: double.parse(shopData['delivery_price'].toString()),
        deliveryType: int.parse(shopData['delivery_type'].toString()),
        rating: 5, //double.parse(shopData['rating'].toString()),
        openHours: shopData['open_hour'].substring(0, 5),
        closeHours: shopData['close_hour'].substring(0, 5));

    int index = shops.indexWhere((item) => item.id == shopData['id']);
    if (index > -1) {
      shops[index] = shop;
    } else {
      shops.add(shop);
    }

    defaultShop.value = shop;

    getTimeUnits(shop.id!);

    final box = GetStorage();
    box.write('shops', shops.map((shop) => shop.toJson()).toList());

    BrandsController brandsController = Get.put(BrandsController());
    BannerController bannerController = Get.put(BannerController());
    CategoryController categoryController = Get.put(CategoryController());
    ChatController chatController = Get.put(ChatController());
    CartController cartController = Get.put(CartController());
    NotificationController notificationController =
        Get.put(NotificationController());

    notificationController.getNotifications();
    cartController.cartProducts.value = [];
    cartController.cartProducts.refresh();

    brandsController.brandCategoriesList.value = [];
    brandsController.brandCategoriesList.refresh();
    brandsController.brandProductsList.value = {};
    brandsController.brandProductsList.refresh();
    brandsController.homeBrandsList.value = [];
    brandsController.homeBrandsList.refresh();
    brandsController.getBrandCategories();
    brandsController.getAllBrands();

    bannerController.bannerList.value = [];
    bannerController.bannerList.refresh();
    bannerController.bannerProducts.value = [];
    bannerController.bannerProducts.refresh();
    bannerController.load.value = true;
    bannerController.load.refresh();
    chatController.getShopUser();

    categoryController.categoryProductList.value = {};
    categoryController.categoryProductList.refresh();
    categoryController.categoryList.value = [];
    categoryController.categoryList.refresh();
    categoryController.getCategories(-1, 10, 0);

    Get.toNamed("/home");
  }

  void setDefaultShop(int index) {
    int indexDefault =
        savedShopList.indexWhere((item) => item.isDefault == true);
    if (indexDefault > -1 && savedShopList.length > index) {
      savedShopList[indexDefault].isDefault = false;
    }

    if (savedShopList.length > index) {
      savedShopList[index].isDefault = true;
      defaultShop.value = savedShopList[index];

      getTimeUnits(savedShopList[index].id!);
    }

    final box = GetStorage();
    box.write('shops', savedShopList.map((shop) => shop.toJson()).toList());

    BrandsController brandsController = Get.put(BrandsController());
    BannerController bannerController = Get.put(BannerController());
    CategoryController categoryController = Get.put(CategoryController());
    ChatController chatController = Get.put(ChatController());
    CartController cartController = Get.put(CartController());
    NotificationController notificationController =
        Get.put(NotificationController());

    notificationController.getNotifications();
    cartController.cartProducts.value = [];
    cartController.cartProducts.refresh();

    brandsController.brandCategoriesList.value = [];
    brandsController.brandCategoriesList.refresh();
    brandsController.brandProductsList.value = {};
    brandsController.brandProductsList.refresh();
    brandsController.homeBrandsList.value = [];
    brandsController.homeBrandsList.refresh();
    brandsController.getBrandCategories();
    brandsController.getAllBrands();

    bannerController.bannerList.value = [];
    bannerController.bannerList.refresh();
    bannerController.bannerProducts.value = [];
    bannerController.bannerProducts.refresh();
    bannerController.load.value = true;
    bannerController.load.refresh();
    chatController.getShopUser();

    categoryController.categoryProductList.value = {};
    categoryController.categoryProductList.refresh();
    categoryController.categoryList.value = [];
    categoryController.categoryList.refresh();
    categoryController.getCategories(-1, 10, 0);

    Get.toNamed("/home");
  }

  Future<void> getTimeUnits(int shopId) async {
    List<TimeUnit> timeUnits = [];

    Map<String, dynamic> data = await shopsTimeUnitsRequest(shopId);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];
        timeUnits.add(TimeUnit(id: item['id'], name: item['name']));
      }

      shopTimeUnitsList.value = timeUnits;
      shopTimeUnitsList.refresh();
    }
  }
}
