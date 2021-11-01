import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2)),
    );
  }
}
