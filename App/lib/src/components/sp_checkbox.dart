import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpCheckBox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String? activeText;
  final String? inactiveText;

  SpCheckBox({this.value, this.onChanged, this.activeText, this.inactiveText});

  @override
  SpCheckBoxState createState() => SpCheckBoxState();
}

class SpCheckBoxState extends State<SpCheckBox>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value! ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value! ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged!(true)
                : widget.onChanged!(false);
          },
          child: Container(
            width: 77.0,
            height: 32.0,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation!.value == Alignment.centerRight
                    ? Color.fromRGBO(19, 20, 21, 1)
                    : Color.fromRGBO(232, 232, 232, 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (_circleAnimation!.value == Alignment.centerRight)
                  Text(
                    widget.activeText!,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                        fontSize: 12.sp),
                  ),
                Align(
                  alignment: _circleAnimation!.value,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: _circleAnimation!.value ==
                                      Alignment.centerLeft
                                  ? Color.fromRGBO(209, 209, 209, 1)
                                  : Color.fromRGBO(8, 9, 11, 1),
                              offset: Offset(0, 1),
                              blurRadius: 1,
                              spreadRadius: 0)
                        ],
                        shape: BoxShape.circle,
                        color: _circleAnimation!.value == Alignment.centerLeft
                            ? Color.fromRGBO(250, 250, 247, 1)
                            : Color.fromRGBO(37, 48, 63, 1)),
                    child: Icon(
                      const IconData(0xefd8, fontFamily: "MIcon"),
                      color: Color.fromRGBO(232, 232, 232, 1),
                      size: 16.sp,
                    ),
                  ),
                ),
                if (_circleAnimation!.value == Alignment.centerLeft)
                  Text(
                    widget.inactiveText!,
                    style: TextStyle(
                        color: Color.fromRGBO(136, 136, 126, 1),
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                        fontSize: 12.sp),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
