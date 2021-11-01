import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/models/banner.dart' as BannerModel;
import 'package:githubit/src/utils/hex_color.dart';

class BannerItem extends StatelessWidget {
  final BannerModel.Banner? banner;
  final bool? isDetail;
  final Function()? onTap;

  BannerItem({this.banner, this.isDetail = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 1.sw - 30,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      margin: EdgeInsets.only(right: !isDetail! ? 0 : 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              "$GLOBAL_IMAGE_URL${banner!.imageUrl}",
            ),
            fit: BoxFit.cover,
          ),
          color: HexColor(banner!.backColor!)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: banner!.position == 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 0.5.sw,
            child: Text(
              "${banner!.title}",
              softWrap: true,
              textAlign:
                  banner!.position == 1 ? TextAlign.start : TextAlign.end,
              maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                  letterSpacing: -0.5,
                  height: 1,
                  color: HexColor(banner!.titleColor!)),
            ),
          ),
          Container(
            width: 0.5.sw,
            child: Text(
              "${banner!.subTitle}",
              softWrap: true,
              textAlign:
                  banner!.position == 1 ? TextAlign.start : TextAlign.end,
              maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  letterSpacing: -0.5,
                  color: HexColor(banner!.titleColor!)),
            ),
          ),
          if (isDetail!)
            InkWell(
              child: Container(
                height: 34,
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: HexColor(banner!.buttonColor!),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "${banner!.buttonText}",
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.5,
                      color: HexColor(banner!.buttonTextColor!)),
                ),
              ),
              onTap: onTap,
            )
        ],
      ),
    );
  }
}
