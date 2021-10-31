import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/components/error_dialog.dart';
import 'package:githubit/src/components/success_alert.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/models/user.dart' as UserModel;
import 'package:githubit/src/requests/sign_up_request.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpController extends GetxController {
  var loading = false.obs;
  var loadingSocial = false.obs;
  var error = "";
  var password = "".obs;
  var passwordConfirm = "".obs;
  var phone = "+".obs;
  var name = "".obs;
  var surname = "".obs;
  var code = "".obs;
  var verificationId = "".obs;
  AuthController authController = Get.put(AuthController());
  StreamController<ErrorAnimationType>? errorController;

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  Future<void> signUpWithSocial(
      String socialId, String name, String email, String photoUrl) async {
    loadingSocial.value = true;

    int index = name.indexOf(" ");
    String firstName = index > -1 ? name.substring(0, index).trim() : name;
    String surname = index > -1 && name.substring(index).length > 0
        ? name.substring(index)
        : name;

    Map<String, dynamic> data = await signUpRequest(firstName, surname, "",
        email, "", 2, socialId, authController.token.value);

    if (data['success'] != null) {
      if (data['success']) {
        Get.bottomSheet(SuccessAlert(
          message: "Successfully registered".tr,
          onClose: () {
            Get.back();
          },
        ));
        setUser(data['data']);
        Future.delayed(1.seconds, () async {
          authController.getUserInfoAndRedirect();
        });
      } else {
        Get.bottomSheet(ErrorAlert(
          message: "You are already registered".tr,
          onClose: () {
            Get.back();
          },
        ));
      }
    } else if (data['error'] != null) {
      Get.bottomSheet(ErrorAlert(
        message: "Error occured in registration".tr,
        onClose: () {
          Get.back();
        },
      ));
    }

    loadingSocial.value = false;
  }

  Future<void> signUpWithPhone() async {
    loading.value = true;

    if (password.value.length < 6) {
      Get.bottomSheet(ErrorAlert(
        message: "Password length should be at least 6 characters".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else if (password.value != passwordConfirm.value) {
      Get.bottomSheet(ErrorAlert(
        message: "Password and confirm password mismatch".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else if (name.value.length < 4) {
      Get.bottomSheet(ErrorAlert(
        message: "Name length should be at least 4 characters".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else if (surname.value.length < 4) {
      Get.bottomSheet(ErrorAlert(
        message: "Surname length should be at least 4 characters".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else if (phone.value.length < 4) {
      Get.bottomSheet(ErrorAlert(
        message: "Phone length should be at least 4 characters".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else {
      print(phone.value);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone.value,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          loading.value = false;
          if (e.code == 'invalid-phone-number') {
            Get.bottomSheet(ErrorAlert(
              message: "Phone number is not valid".tr,
              onClose: () {
                loading.value = false;
                Get.back();
              },
            ));
          }
        },
        codeSent: (String vId, int? resendToken) {
          loading.value = false;
          verificationId.value = vId;
          Get.toNamed("/verifyPhone");
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<void> confirmSignUpWithPhone() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: code.value);

    try {
      UserCredential userData =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userData.user != null) {
        Map<String, dynamic> data = await signUpRequest(
            name.value,
            surname.value,
            phone.value,
            "",
            password.value,
            1,
            "",
            authController.token.value);
        if (data['success'] != null) {
          if (data['success']) {
            Get.bottomSheet(SuccessAlert(
              message: "Successfully registered".tr,
              onClose: () {
                Get.back();
              },
            ));
            setUser(data['data']);
            Future.delayed(1.seconds, () async {
              authController.getUserInfoAndRedirect();
            });
          } else
            Get.bottomSheet(ErrorAlert(
              message: "You are already registered".tr,
              onClose: () {
                Get.back();
              },
            ));
        } else
          Get.bottomSheet(ErrorAlert(
            message: "Error occured in registration",
            onClose: () {
              Get.back();
            },
          ));
      }
    } catch (e) {
      Get.bottomSheet(ErrorAlert(
        message: "Sms code is invalid".tr,
        onClose: () {
          Get.back();
        },
      ));
    }
  }

  void onChangeName(String text) {
    name.value = text;
  }

  void onChangeSurname(String text) {
    surname.value = text;
  }

  void onChangePhone(String text) {
    phone.value = text;
  }

  void onChangePassword(String text) {
    password.value = text;
  }

  void onChangePasswordConfirm(String text) {
    passwordConfirm.value = text;
  }

  void onChangeSmsCode(String text) {
    code.value = text;
  }

  void setUser(Map<String, dynamic> data) {
    String name = data['name'];
    String surname = data['surname'];
    String phone = data['phone'] ?? "";
    String imageUrl = data['image_url'] ?? "";
    int id = data['id'];
    String email = data['email'] ?? "";
    String token = data['token'];

    UserModel.User user = UserModel.User(
        name: name,
        surname: surname,
        phone: phone,
        imageUrl: imageUrl,
        id: id,
        email: email,
        token: token);

    authController.user.value = user;
    authController.user.refresh();

    final box = GetStorage();
    box.write('user', user.toJson());
  }

  Future<void> resetPasswordWithPhone() async {
    loading.value = true;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        loading.value = false;
        if (e.code == 'invalid-phone-number') {
          Get.bottomSheet(ErrorAlert(
            message: "Phone number is not valid".tr,
            onClose: () {
              Get.back();
            },
          ));
        }
      },
      codeSent: (String vId, int? resendToken) {
        loading.value = false;
        verificationId.value = vId;
        Get.toNamed("/verifyPhone", arguments: {"phone": phone.value});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
