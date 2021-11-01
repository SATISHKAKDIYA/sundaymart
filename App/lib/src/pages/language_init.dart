import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/language_item.dart';
import 'package:githubit/src/components/search_input.dart';
import 'package:githubit/src/controllers/language_controller.dart';

class LanguageInit extends GetView<LanguageController> {
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
            title: "Select language".tr,
            hasBack: false,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchInput(
              title: "Search language".tr,
              hasSuffix: false,
              onChange: (text) => controller.onSearch(text),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              return Column(
                children: controller.languages.map((item) {
                  return LanguageItem(
                    isChecked: controller.activeLanguageId.value == item.id,
                    text: item.name,
                    imageUrl: item.image,
                    onPress: () {
                      controller.language.value = item.shortName!;
                      controller.activeLanguageId.value = item.id!;
                    },
                  );
                }).toList(),
              );
            })
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
        child: TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(0))),
            onPressed: () => controller.setLanguage(
                controller.language.value, controller.activeLanguageId.value),
            child: Container(
              width: 1.sw - 30,
              height: 60,
              alignment: Alignment.center,
              child: Text(
                "Next".tr,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 165, 36, 1),
                  borderRadius: BorderRadius.circular(30)),
            )),
      ),
    );
  }
}
