import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/components/success_alert.dart';
import 'package:githubit/src/controllers/order_controller.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/requests/update_user_request.dart';
import 'package:githubit/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  var isConnected = true.obs;
  var user = Rxn<User>();
  var token = "".obs;
  var profilePercentage = 0.obs;
  var showConfirmPassword = false.obs;
  var showNewPassword = false.obs;
  var showNewPasswordConfirm = false.obs;
  var currentPassword = "".obs;
  var newPassword = "".obs;
  var newPasswordConfirm = "".obs;

  final ImagePicker picker = ImagePicker();
  var profileImage = Rxn<XFile>();
  var name = "".obs;
  var surname = "".obs;
  var phone = "".obs;
  var email = "".obs;
  var gender = 0.obs;
  var image = "".obs;
  var load = true.obs;
  var route = "".obs;

  final OrderController orderController = Get.put(OrderController());

  @override
  void onInit() {
    super.onInit();

    connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await getConnectivity();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.toNamed("/notifications");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    route.value = "";
  }

  @override
  void onReady() {
    super.onReady();

    getConnectivity();
    getPushToken();
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> getConnectivity() async {
    try {
      bool isConnectedResult = await Utils.checkInternetConnectivity();
      isConnected.value = isConnectedResult;
      Future.delayed(Duration(milliseconds: 3000), () {
        getUserInfoAndRedirect();
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
    return Future.value(null);
  }

  Future<void> getUserInfoAndRedirect() async {
    if (!isConnected.value)
      Get.offAndToNamed("/noConnection");
    else {
      final box = GetStorage();
      final user = box.read('user') ?? null;
      final language = box.read('language') ?? null;
      final addressList = box.read('addressList') ?? null;

      if (language != null) {
        if (user != null) {
          if (addressList == null)
            Get.offAndToNamed("/location");
          else {
            //route.value = "store";
            Get.offAndToNamed("/store");
          }
        } else {
          Get.offAndToNamed("/signin");
        }
      } else {
        Get.offAndToNamed("/languageInit");
      }
    }
  }

  User? getUser() {
    final box = GetStorage();
    final userData = box.read('user') ?? null;
    if (userData == null) {
      if (user.value != null && user.value!.id != null) {
        name.value = user.value!.name!;
        surname.value = user.value!.surname!;
        phone.value = user.value!.phone!;
        email.value = user.value!.email!;
        gender.value = user.value!.gender!;
        currentPassword.value = user.value!.password!;
        image.value = user.value!.imageUrl!;

        checkUser();
      }

      return user.value;
    } else {
      user.value = User.fromJson(userData);
      if (user.value != null && user.value!.id != null) {
        name.value = user.value!.name!;
        surname.value = user.value!.surname!;
        phone.value = user.value!.phone!;
        email.value = user.value!.email!;
        gender.value = user.value!.gender!;
        currentPassword.value = user.value!.password ?? "";
        image.value = user.value!.imageUrl ?? "";
      }
      checkUser();
    }

    return userData != null ? User.fromJson(userData) : null;
  }

  void logout() {
    final box = GetStorage();
    box.remove('user');
    Get.offAllNamed("/signin");
  }

  Future<void> getPushToken() async {
    token.value = await FirebaseMessaging.instance.getToken() ?? "";
    token.refresh();
  }

  void checkUser() {
    profilePercentage.value = 0;
    if (name.value.length > 0) profilePercentage.value += 12;
    if (surname.value.length > 0) profilePercentage.value += 12;
    if (phone.value.length > 0) profilePercentage.value += 12;
    if (email.value.length > 0) profilePercentage.value += 12;
    if (gender.value >= 0) profilePercentage.value += 12;
    if (currentPassword.value.length > 0) profilePercentage.value += 12;
    if (profileImage.value != null || image.value.length > 4)
      profilePercentage.value += 28;

    profilePercentage.refresh();
  }

  Future<void> updateUser() async {
    if (load.value) {
      load.value = false;
      Map<String, dynamic> data = await updateUserRequest(
          user.value!.id!,
          name.value,
          surname.value,
          phone.value,
          email.value,
          newPassword.value.length > 0
              ? newPassword.value
              : currentPassword.value,
          image.value,
          gender.value);

      if (data['success']) {
        User userOld = user.value!;
        User updatedUser = User(
            id: userOld.id,
            name: name.value,
            surname: surname.value,
            password: newPassword.value.length > 0
                ? newPassword.value
                : currentPassword.value,
            gender: gender.value,
            phone: phone.value,
            imageUrl: image.value,
            email: email.value);

        user.value = updatedUser;

        load.value = true;

        Get.bottomSheet(SuccessAlert(
          message: "Successfully updated".tr,
          onClose: () {
            Get.back();
          },
        ));

        final box = GetStorage();
        box.write('user', updatedUser.toJson());
      }
    }
  }
}
