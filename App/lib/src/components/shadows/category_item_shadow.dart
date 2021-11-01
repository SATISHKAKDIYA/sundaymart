import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: EdgeInsets.only(right: 15),
          width: 80,
          child: Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                width: 80,
                height: 20,
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
