import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryProductItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 170,
          height: 283,
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 170,
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 140,
                          height: 100,
                          color: Colors.white,
                        ),
                        Container(
                          height: 16,
                          color: Colors.white,
                          width: 60,
                        ),
                        Container(
                          width: 40,
                          height: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                width: 170,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 20,
                      width: 40,
                      color: Colors.white,
                    ),
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
