import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/config/global_config.dart';

class NotificationItem extends StatelessWidget {
  final String? title;
  final String? date;
  final bool? isReaded;
  final bool? isOpen;
  final String? imageUrl;
  final bool? hasImage;
  final String? description;

  const NotificationItem(
      {this.title,
      this.date,
      this.isReaded = false,
      this.isOpen = false,
      this.imageUrl,
      this.hasImage = false,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(children: <Widget>[
          Container(
            height: 73,
            width: 1.sw - 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!isReaded!)
                  Container(
                    height: 49,
                    width: 4,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(69, 165, 36, 1),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ),
                Container(
                  width: 1.sw - 80,
                  margin: EdgeInsets.only(left: 19),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            height: 1.7,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      Text(
                        "$date",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            height: 1.5,
                            color: Color.fromRGBO(136, 136, 126, 1)),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 20,
                  child: Icon(
                    isOpen!
                        ? const IconData(0xea4e, fontFamily: 'MIcon')
                        : const IconData(0xea6e, fontFamily: 'MIcon'),
                    color: Colors.black,
                    size: 24.sp,
                  ),
                )
              ],
            ),
          ),
          if (isOpen!)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Color.fromRGBO(249, 249, 246, 1)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (hasImage!)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          width: 0.3.sw,
                          height: 0.3.sw,
                          fit: BoxFit.fitWidth,
                          imageUrl: "$GLOBAL_IMAGE_URL$imageUrl",
                          placeholder: (context, url) => Container(
                            width: 0.3.sw,
                            height: 0.3.sw,
                            alignment: Alignment.center,
                            child: Icon(
                              const IconData(0xee4b, fontFamily: 'MIcon'),
                              color: Color.fromRGBO(233, 233, 230, 1),
                              size: 40.sp,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                  Container(
                    width: 0.7.sw - 85,
                    child: Html(
                      data: "$description",
                    ),
                  )
                ],
              ),
            )
        ]));
  }
}
