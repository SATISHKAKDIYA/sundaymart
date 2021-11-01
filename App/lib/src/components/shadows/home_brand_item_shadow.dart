import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeBrandItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 120,
          height: 120,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(60)),
        ));
  }
}
