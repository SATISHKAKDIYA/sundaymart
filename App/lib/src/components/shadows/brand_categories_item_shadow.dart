import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class BrandCategoriesItemShadow extends StatelessWidget {
  final bool? isLast;

  BrandCategoriesItemShadow({this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: (1.sw - 50) / 3,
          height: (1.sw - 50) / 3,
          margin: EdgeInsets.only(right: isLast! ? 0 : 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ));
  }
}
