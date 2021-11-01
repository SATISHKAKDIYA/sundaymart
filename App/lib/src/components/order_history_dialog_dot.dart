import 'package:flutter/material.dart';

class OrderHistoryDialogDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Color.fromRGBO(196, 196, 196, 0.44),
          borderRadius: BorderRadius.circular(2)),
    );
  }
}
