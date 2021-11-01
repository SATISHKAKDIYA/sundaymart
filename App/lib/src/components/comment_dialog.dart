import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/product_controller.dart';

class CommentDialog extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: 0.8.sw,
          decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Color.fromRGBO(26, 34, 44, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Add review".tr,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    height: 1.2,
                    letterSpacing: -1,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1)),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Get.isDarkMode
                    ? Color.fromRGBO(130, 139, 150, 1)
                    : Color.fromRGBO(136, 136, 126, 1),
              ),
              SizedBox(
                height: 20,
              ),
              if (controller.productCommentStar.value > 0)
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemSize: 28.sp,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    controller.productCommentStar.value = rating.toInt();
                  },
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 0.13)
                        : Color.fromRGBO(136, 136, 126, 0.13)),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      letterSpacing: -0.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                  onChanged: (text) {
                    controller.productCommentText.value = text;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(0))),
                onPressed: () => controller.saveComment(),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(69, 165, 36, 1),
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  child: Text(
                    "Save review".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
