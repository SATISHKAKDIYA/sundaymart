import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/location_list_item_dropdown.dart';
import 'package:githubit/src/controllers/address_controller.dart';
import 'package:githubit/src/models/address.dart';
import 'package:githubit/src/themes/map_dark_theme.dart';
import 'package:githubit/src/themes/map_light_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationListItem extends StatefulWidget {
  final Address? address;
  final int? index;

  LocationListItem({this.address, this.index});

  LocationListItemState createState() => LocationListItemState();
}

class LocationListItemState extends State<LocationListItem> {
  final AddressController addressController = Get.put(AddressController());
  bool loadGoogleMap = false;
  bool isMenuOpen = false;

  CameraPosition? _kGooglePlex = CameraPosition(
    target: LatLng(MAP_DEFAULT_LATITUDE, MAP_DEFAULT_LONGITUDE),
    zoom: 14,
  );

  @override
  void initState() {
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.address!.lat!, widget.address!.lng!),
      zoom: 14,
    );

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        loadGoogleMap = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    return Container(
      height: 250,
      width: 1.sw - 20,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: Stack(
        children: <Widget>[
          Container(
            width: 1.sw - 30,
            height: 80,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Get.isDarkMode
                    ? Color.fromRGBO(37, 48, 63, 1)
                    : Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color.fromRGBO(169, 169, 150, 0.13),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0)
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Get.isDarkMode
                          ? Color.fromRGBO(19, 20, 21, 1)
                          : Color.fromRGBO(243, 243, 240, 1)),
                  child: Icon(
                    const IconData(0xef88, fontFamily: 'MIcon'),
                    size: 24.sp,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 10),
                  width: 1.sw - 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.address!.title}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            height: 1.6,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      Text(
                        "${widget.address!.address}",
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1)),
                      )
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 15,
                    height: 40,
                    child: Icon(
                      const IconData(0xef77, fontFamily: 'MIcon'),
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isMenuOpen = !isMenuOpen;
                    });
                  },
                )
              ],
            ),
          ),
          if (widget.address!.isDefault!)
            Positioned(
                left: 0,
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(69, 165, 36, 1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4))),
                  width: 4,
                  height: 60,
                )),
          Positioned(
              top: 80,
              left: 0,
              child: Container(
                  height: 170,
                  width: 1.sw - 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    child: loadGoogleMap
                        ? GoogleMap(
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _kGooglePlex!,
                            onMapCreated: (GoogleMapController controller) {
                              controller.setMapStyle(json.encode(Get.isDarkMode
                                  ? MAP_DARK_THEME
                                  : MAP_LIGHT_THEME));
                              _controller.complete(controller);
                            },
                          )
                        : Container(),
                  ))),
          if (isMenuOpen)
            Positioned(
                right: 5,
                top: 50,
                child: Stack(
                  children: <Widget>[
                    LocationListItemDropDown(
                      onDelete: () {
                        addressController.onDeleteLocation(widget.index!);
                      },
                      onEdit: () {},
                    ),
                    Positioned(
                        top: 5,
                        right: 10,
                        child: Container(
                          width: 20,
                          height: 20,
                          transform: Matrix4.rotationZ(45 * pi / 180),
                          transformAlignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Color.fromRGBO(37, 48, 63, 1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )),
                  ],
                )),
        ],
      ),
    );
  }
}
