import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/qa_item.dart';
import 'package:githubit/src/controllers/faq_controller.dart';
import 'package:githubit/src/models/faq.dart';

class Qa extends GetView<FaqController> {
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
            title: "FAQ".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (controller.shopController.defaultShop.value != null &&
                controller.shopController.defaultShop.value!.id != null)
              Container(
                padding: EdgeInsets.all(15),
                child: FutureBuilder<List<Faq>>(
                  future: controller.getFaq(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Faq> faqList = snapshot.data!;
                      return Column(
                        children: faqList.map((item) {
                          return QaItem(
                            question: item.question,
                            answer: item.answer,
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container();
                  },
                ),
              ),
            if (controller.shopController.defaultShop.value == null ||
                controller.shopController.defaultShop.value!.id == null)
              Empty(message: "To see about, please, select shop")
          ],
        ),
      ),
    );
  }
}
