import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProccessFull extends StatelessWidget {
  final bool? isFilled;

  ProccessFull({this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 6,
      decoration: BoxDecoration(
          color: isFilled!
              ? Get.isDarkMode
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Color.fromRGBO(0, 0, 0, 1)
              : Color.fromRGBO(136, 136, 126, 0.21),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
