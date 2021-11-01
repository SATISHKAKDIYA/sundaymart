import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountDownTimer extends StatefulWidget {
  final double? width;
  final int? startTime;
  final int? endTime;

  const CountDownTimer({this.width, this.startTime, this.endTime});

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer? timer;
  int startTime = 0;

  @override
  void initState() {
    super.initState();
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    setState(() {
      startTime = (widget.endTime! - now) ~/ 1000;
    });

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();

    timer!.cancel();
    timer = null;
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    } else {
      timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          setState(() {
            if (startTime < 1) {
              timer.cancel();
            } else {
              startTime = startTime - 1;
            }
          });
        },
      );
    }
  }

  String getTimeString() {
    int time = startTime;
    int hour = time ~/ 3600;
    time = time - hour * 3600;
    int minute = time ~/ 60;
    time = time - minute * 60;
    String hourString = hour < 10 ? "0$hour" : "$hour";
    String minuteString = minute < 10 ? "0$minute" : "$minute";
    String secondString = time < 10 ? "0$time" : "$time";

    return "$hourString : $minuteString : $secondString";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 184, 0, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Text(getTimeString(),
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              letterSpacing: -0.4,
              color: Color.fromRGBO(255, 255, 255, 1))),
    );
  }
}
