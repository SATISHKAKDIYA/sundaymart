import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDot extends StatelessWidget {
  final bool? isFilled;
  ProfileDot({this.isFilled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.082.sw,
      height: 11,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isFilled! ? Colors.white : Color.fromRGBO(54, 126, 28, 1)),
    );
  }
}
