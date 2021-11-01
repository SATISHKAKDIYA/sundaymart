import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QaItem extends StatefulWidget {
  final String? question;
  final String? answer;

  QaItem({this.answer, this.question});

  QaItemState createState() => QaItemState();
}

class QaItemState extends State<QaItem> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: Color.fromRGBO(169, 169, 150, 0.13))
          ]),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 1.sw - 100,
                  child: Text(
                    "${widget.question}",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        letterSpacing: -0.5,
                        height: 1.5,
                        color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
                isOpen
                    ? Icon(
                        const IconData(0xea78, fontFamily: "MIcon"),
                        size: 28.sp,
                        color: Colors.black,
                      )
                    : Icon(
                        const IconData(0xea4e, fontFamily: "MIcon"),
                        size: 28.sp,
                        color: Colors.black,
                      )
              ],
            ),
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
          ),
          if (isOpen)
            Container(
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.answer}",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    letterSpacing: -0.5,
                    height: 1.7,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
            )
        ],
      ),
    );
  }
}
