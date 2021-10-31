import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TextInput extends StatefulWidget {
  final String? title;
  final String? placeholder;
  final String? defaultValue;
  final Function(String)? onChange;
  final TextInputType? type;
  final bool? isFull;

  TextInput(
      {this.title,
      this.placeholder,
      this.onChange,
      this.defaultValue = "",
      this.isFull = false,
      this.type = TextInputType.text});

  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  var textController = TextEditingController();

  @override
  void initState() {
    textController.text = "${widget.defaultValue}";
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Container(
      margin: EdgeInsets.only(top: 0.023.sh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title!,
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1)),
          ),
          Container(
            width: widget.isFull! ? 1.sw : 0.845.sw,
            child: TextField(
              controller: textController,
              onChanged: widget.onChange,
              keyboardType: widget.type,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1)),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(136, 136, 126, 0.26)),
                  hintText: widget.placeholder),
            ),
          )
        ],
      ),
    );
  }
}
