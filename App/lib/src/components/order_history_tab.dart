import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistoryTab extends StatelessWidget {
  final String? name;
  final int? type;
  final int? count;

  OrderHistoryTab({this.name, this.type, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
              right: 0,
              top: 10,
              child: type == 2
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(255, 184, 0, 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$count",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: Colors.white),
                      ),
                    )
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 2,
                              color: type == 1
                                  ? Color.fromRGBO(69, 165, 36, 1)
                                  : Color.fromRGBO(222, 31, 54, 1))),
                    )),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              "$name",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
