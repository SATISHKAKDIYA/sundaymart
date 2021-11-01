import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShopListVerticalItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(left: 6, right: 14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
              ),
              Container(
                width: 1.sw - 130,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: 0.6.sw,
                      height: 10,
                      color: Colors.white,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      width: 0.4.sw,
                      height: 10,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
