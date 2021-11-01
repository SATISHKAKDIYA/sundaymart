import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/banner_item.dart';
import 'package:githubit/src/components/shadows/banner_item_shadow.dart';
import 'package:githubit/src/controllers/banner_controller.dart';
import 'package:githubit/src/models/banner.dart' as BannerModel;

class Banners extends GetView<BannerController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bannerList.length == 0)
        return FutureBuilder<void>(
          future: controller.getBanners(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (controller.bannerList.length > 0)
                return Container(
                  width: 1.sw,
                  height: 180,
                  margin: EdgeInsets.only(top: 30),
                  child: ListView.builder(
                      itemCount: controller.bannerList.length,
                      padding: EdgeInsets.only(left: 15),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        BannerModel.Banner banner =
                            controller.bannerList[index];
                        return BannerItem(
                          banner: banner,
                        );
                      }),
                );
              else
                return Container();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Container(
                padding: EdgeInsets.only(left: 15),
                margin: EdgeInsets.only(top: 30),
                width: 1.sw,
                height: 180,
                child: BannerItemShadow());
          },
        );
      else
        return Container(
          width: 1.sw,
          height: 180,
          margin: EdgeInsets.only(top: 30),
          child: ListView.builder(
              itemCount: controller.bannerList.length,
              padding: EdgeInsets.only(left: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                BannerModel.Banner banner = controller.bannerList[index];
                return BannerItem(
                  banner: banner,
                  onTap: () {
                    controller.activeBanner.value = banner;
                    controller.bannerProducts.value = [];
                    controller.bannerProducts.refresh();
                    controller.productController.clearFilter();
                    controller.load.value = true;
                    Get.toNamed("/bannerDetails");
                  },
                );
              }),
        );
    });
  }
}
