import 'package:get/get.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/requests/order_count_request.dart';
import 'package:githubit/src/requests/order_history_request.dart';

class OrderController extends GetxController {
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

  var newOrderCount = 0.obs;
  var load = false.obs;
  var ordersList = [].obs;

  Future<int> getOrderCount(int userId) async {
    Map<String, dynamic> data = await orderCountRequest(userId);
    int count = 0;
    if (data['success']) {
      count = data['data'];
      newOrderCount.value = data['data'];
      newOrderCount.refresh();
    }

    return count;
  }

  Future<List> getOrderHistory(User user, int status, int idLang) async {
    int limit = 10;
    int offset = 0;
    List orders = [];
    ordersList.value = [];
    ordersList.refresh();
    if (load.value) {
      Map<String, dynamic> data =
          await orderHistoryRequest(user.id!, status, idLang, limit, offset);

      if (data['success']) {
        orders = data['data'];
        ordersList.value = data['data'];
        ordersList.refresh();
        load.value = false;
        load.refresh();
      }
    }

    return orders;
  }

  String getTime(String time) {
    String stringTime = "";
    DateTime dateTime = DateTime.parse(time);
    String apm = "am";
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String minuteString = "$minute";
    String hourString = "$hour";
    if (hour > 12) {
      apm = "pm";
      hour = hour - 12;
    } else if (hour < 10) {
      hourString = "0$hour";
    }

    if (minute < 10) minuteString = "0$minute";

    stringTime =
        "${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} | $hourString:$minuteString $apm";

    return stringTime;
  }

  String getTime2(String time) {
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
        "${dateTime.day} ${months[dateTime.month - 1]}, $hourString:$minuteString";

    return stringTime;
  }

  String getOnlyTime(String time) {
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

    stringTime = "$hourString:$minuteString";

    return stringTime != "00:00" ? stringTime : "";
  }
}
