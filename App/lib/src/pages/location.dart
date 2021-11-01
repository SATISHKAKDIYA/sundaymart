import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/location_search_item.dart';
import 'package:githubit/src/controllers/address_controller.dart';
import 'package:githubit/src/themes/map_dark_theme.dart';
import 'package:githubit/src/themes/map_light_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as GooglePlace;

class LocationPage extends GetView<AddressController> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(MAP_DEFAULT_LATITUDE, MAP_DEFAULT_LONGITUDE),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    controller.mapController = Completer();

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: Obx(() => Container(
            width: 1.sw,
            height: 1.sh,
            child: Stack(
              children: <Widget>[
                Container(
                  width: 1.sw,
                  height: 1.sh,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    onTap: (LatLng data) {
                      controller.moveToCoords(data.latitude, data.longitude);
                      controller.getPlaceName(data.latitude, data.longitude);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: Set<Marker>.of(controller.markers.values),
                    padding: EdgeInsets.only(top: 600, right: 0),
                    zoomControlsEnabled: false,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController mapcontroller) {
                      mapcontroller.setMapStyle(json.encode(
                          Get.isDarkMode ? MAP_DARK_THEME : MAP_LIGHT_THEME));
                      if (!controller.mapController!.isCompleted)
                        controller.mapController!.complete(mapcontroller);
                    },
                  ),
                ),
                Positioned(
                    top: 53,
                    left: 15,
                    right: 15,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 1.sw - 30,
                          decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(169, 169, 150, 0.13),
                                    offset: Offset(0, 2),
                                    blurRadius: 2,
                                    spreadRadius: 0)
                              ],
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(37, 48, 63, 1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: TextField(
                            controller: new TextEditingController(
                                text: controller.searchText.value)
                              ..selection = TextSelection.fromPosition(
                                TextPosition(
                                    offset: controller.searchText.value.length),
                              ),
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) =>
                                controller.onChangeAddressSearchText(text),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  const IconData(0xf0d1, fontFamily: 'MIcon'),
                                  size: 22.sp,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    controller.onChangeAddressSearchText(""),
                                icon: Icon(
                                  const IconData(0xeb99, fontFamily: 'MIcon'),
                                  size: 20.sp,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (controller.isSearch.value)
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(169, 169, 150, 0.13),
                                      offset: Offset(0, 2),
                                      blurRadius: 2,
                                      spreadRadius: 0)
                                ],
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(37, 48, 63, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: controller.predictions.map((element) {
                                int index =
                                    controller.predictions.indexOf(element);
                                GooglePlace.AutocompletePrediction prediction =
                                    element;

                                return LocationSearchItem(
                                  mainText:
                                      prediction.structuredFormatting!.mainText,
                                  address: prediction
                                      .structuredFormatting!.secondaryText,
                                  onClickRaw: (text) =>
                                      controller.getLatLngFromName(text),
                                  onClickIcon: (text) =>
                                      controller.onChangeSearchText(text),
                                  isLast: index ==
                                      (controller.predictions.length - 1),
                                );
                              }).toList(),
                            ),
                          )
                      ],
                    )),
              ],
            ),
          )),
      floatingActionButton: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0))),
        onPressed: controller.currentLocation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color.fromRGBO(166, 166, 166, 0.25))
              ],
              borderRadius: BorderRadius.circular(30),
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Colors.white),
          alignment: Alignment.center,
          child: Icon(
            const IconData(0xef88, fontFamily: 'MIcon'),
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 32.sp,
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(0))),
          child: Container(
            width: 1.sw - 30,
            height: 60,
            alignment: Alignment.center,
            child: Text(
              "Enter location".tr,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Color.fromRGBO(255, 255, 255, 1)),
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(69, 165, 36, 1),
                borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: controller.onConfirmLocation,
        ),
      ),
    );
  }
}
