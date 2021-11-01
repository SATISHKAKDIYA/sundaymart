import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/shop.dart';
import 'package:githubit/src/requests/notifications_request.dart';

class NotificationController extends GetxController {
  List<String> months = [
    "January".tr,
    "February".tr,
    "March".tr,
    "April".tr,
    "May".tr,
    "June".tr,
    "July".tr,
    "August".tr,
    "September".tr,
    "October".tr,
    "November".tr,
    "December".tr
  ];

  final ShopController shopController = Get.put(ShopController());
  final LanguageController languageController = Get.put(LanguageController());
  var date = "".obs;
  var readedNotificationIds = [].obs;
  var activeNotificationId = 0.obs;
  var notificationsList = [].obs;
  var unreadedNotifications = 0.obs;

  @override
  void onInit() {
    super.onInit();

    if (date.value.length == 0) {
      final box = GetStorage();
      String newDate = box.read("date") ?? "";
      if (newDate.length == 0) {
        DateTime now = DateTime.now();
        int hour = now.hour;
        int minute = now.minute;
        int second = now.second;
        int month = now.month;
        int day = now.day;

        date.value =
            "${now.year}-${month < 10 ? '0$month' : month}-${day < 10 ? '0$day' : day} ${hour < 10 ? '0$hour' : hour}:${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}";

        box.write('date', date.value);
      } else
        date.value = newDate;
    }
  }

  @override
  void onReady() {
    super.onReady();

    getNotifications();
  }

  Future<List> getNotifications() async {
    List notifications = [];
    Shop? shop = shopController.defaultShop.value;

    if (shop != null && shop.id != null) {
      Map<String, dynamic> data = await notificationsRequest(
          shop.id!, languageController.activeLanguageId.value, date.value);
      if (data['success']) {
        notifications = data['data'];
        notificationsList.value = notifications;
      }
    }

    getUnreadedNotifications();

    return notifications;
  }

  String getTime(String time) {
    String stringTime = "";
    DateTime dateTime = DateTime.parse(time);
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String minuteString = "$minute";
    String hourString = "$hour";
    if (hour < 10) {
      hourString = "0$hour";
    }

    if (minute < 10) minuteString = "0$minute";

    stringTime =
        "${dateTime.day} ${months[dateTime.month - 1]} $hourString:$minuteString";

    return stringTime;
  }

  void getUnreadedNotifications() {
    int i = 0;
    for (int m = 0; m < notificationsList.length; m++) {
      int index = readedNotificationIds
          .indexWhere((element) => element == notificationsList[m]['id']);
      if (index == -1) i++;
    }

    unreadedNotifications.value = i;
  }
}
