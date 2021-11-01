import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/location_list_item.dart';
import 'package:githubit/src/controllers/address_controller.dart';

class LocationList extends GetView<AddressController> {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: PreferredSize(
          preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
          child: AppBarCustom(
              title: "Address list".tr,
              hasBack: true,
              actions: Container(
                height: 30,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(28)),
                child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(69, 165, 36, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ))),
                    onPressed: () => Get.toNamed("/location"),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(
                            const IconData(0xea13, fontFamily: 'MIcon'),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Text(
                          "Add address".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ],
                    )),
              ))),
      body: Obx(() {
        if (controller.addressList.length > 0)
          return Container(
            width: 1.sw,
            height: 1.sh,
            child: ListView.builder(
                itemCount: controller.addressList.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 20),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => controller.setDefaultAddress(index),
                    child: LocationListItem(
                      address: controller.addressList[index],
                      index: index,
                    ),
                  );
                }),
          );
        else
          return Empty(
            message: "Saved addresses are not available.".tr,
          );
      }),
    );
  }
}
