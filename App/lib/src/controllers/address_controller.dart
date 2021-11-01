import 'dart:async';

import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/error_dialog.dart';
import 'package:githubit/src/components/location_dialog.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/models/address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as GooglePlace;
import 'package:location/location.dart';

class AddressController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  var isSearch = false.obs;
  var searchText = "".obs;
  var predictions = [].obs;
  GooglePlace.GooglePlace googlePlace =
      GooglePlace.GooglePlace("AIzaSyBgNvtPqsuKcgp26ukVPobjKw0Igx2dp5M");
  Completer<GoogleMapController>? mapController = Completer();
  var markers = <MarkerId, Marker>{}.obs;
  var latitude = MAP_DEFAULT_LATITUDE.obs;
  var longitude = MAP_DEFAULT_LONGITUDE.obs;
  var addressList = <Address>[].obs;
  var title = "".obs;
  var loadGoogleMap = false.obs;
  var initLocation = false.obs;

  @override
  void onInit() {
    super.onInit();

    getSavedAddressList();

    Future.delayed(500.milliseconds, () async {
      loadGoogleMap.value = true;
      getPlaceName(latitude.value, longitude.value);
    });
  }

  List<Address> get addressListData => addressList;

  void getSavedAddressList() {
    final box = GetStorage();
    List<dynamic> data = box.read("addressList") ?? [];
    addressList.value =
        data.map<Address>((item) => Address.fromJson(item)).toList();
  }

  void onChangeAddressSearchText(String text) {
    searchText.value = text;

    getPlacePredictions();
  }

  void currentLocation() async {
    LocationData? currentLocation;
    var location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    if (currentLocation != null) {
      moveToCoords(currentLocation.latitude!, currentLocation.longitude!);
      getPlaceName(currentLocation.latitude!, currentLocation.longitude!);
    }
  }

  void moveToCoords(double lat, double lng) async {
    final GoogleMapController? controller = await mapController!.future;
    latitude.value = lat;
    longitude.value = lng;

    MarkerId _markerId = MarkerId('marker_id_0');
    Marker _marker = Marker(
      markerId: _markerId,
      position: LatLng(lat, lng),
      draggable: false,
    );

    Map<MarkerId, Marker> markerData = {};
    markerData[_markerId] = _marker;

    markers.value = markerData;

    try {
      controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, lng),
          zoom: 17.0,
        ),
      ));
    } catch (e) {}
  }

  Future<void> getPlacePredictions() async {
    if (searchText.value.length > 0) {
      print(searchText.value);
      double lat = latitude.value.toDouble();
      double lng = longitude.value.toDouble();
      var result = await googlePlace.queryAutocomplete
          .get(searchText.value, location: GooglePlace.LatLon(lat, lng));
      if (result != null && result.predictions != null) {
        predictions.value = result.predictions!;
        if (result.predictions!.length > 0) isSearch.value = true;
      }
    } else {
      if (predictions.length > 0) {
        predictions.value = [];
        isSearch.value = false;
      }
    }
  }

  Future<void> getLatLngFromName(placeName) async {
    isSearch.value = false;
    searchText.value = placeName;
    List<Geocoding.Location> location =
        await Geocoding.locationFromAddress(placeName, localeIdentifier: 'en');
    double lat = location[0].latitude;
    double long = location[0].longitude;

    moveToCoords(lat, long);
  }

  Future<void> getPlaceName(lat, lng) async {
    try {
      final List<Geocoding.Placemark> placemarks =
          await Geocoding.placemarkFromCoordinates(lat, lng,
              localeIdentifier: 'en');

      if (placemarks.isNotEmpty) {
        final Geocoding.Placemark pos = placemarks[0];

        List<String> addressData = [];
        addressData.add(pos.locality!);
        addressData.add(pos.subLocality!);
        addressData.add(pos.thoroughfare!);
        addressData.add(pos.name!);

        String placeName = addressData.join(", ");

        searchText.value = placeName;
      }
    } catch (e) {
      searchText.value = "";
    }
  }

  void onChangeSearchText(String text) {
    searchText.value = text;

    getPlacePredictions();
  }

  void addAddress() {
    if (addressListData.length > 0) {
      int indexDefault =
          addressListData.indexWhere((element) => element.isDefault == true);
      if (indexDefault > -1) {
        addressListData[indexDefault].isDefault = false;
      }
    }

    Address address = Address(
        title: title.value,
        address: searchText.value,
        lat: latitude.value,
        lng: longitude.value,
        isDefault: true);

    addressListData.add(address);

    if (addressListData.length > 0) {
      final box = GetStorage();
      box.write(
          "addressList", addressListData.map((item) => item.toJson()).toList());
    }

    title.value = "";
    searchText.value = "";
    latitude.value = MAP_DEFAULT_LATITUDE;
    longitude.value = MAP_DEFAULT_LONGITUDE;
  }

  void onChangeLocationTitle(text) {
    title.value = text;
  }

  void onConfirmLocation() {
    Get.bottomSheet(LocationDialog(
      onChangeTitle: onChangeLocationTitle,
      onSave: onSaveLocation,
    ));
  }

  void onSaveLocation() {
    if (title.value.length > 0) {
      addAddress();
      Get.back();
      if (initLocation.value)
        Get.back();
      else {
        initLocation.value = false;
        authController.getUserInfoAndRedirect();
      }
    } else {
      Get.bottomSheet(ErrorAlert(
        message: "Please add title".tr,
        onClose: () {
          Get.back();
        },
      ));
    }
  }

  void onDeleteLocation(int index) {
    if (addressList.length > index) {
      addressList.removeAt(index);
      addressList.refresh();
    }
  }

  Address getDefaultAddress() {
    List<Address> addressListData = addressList;

    int indexDefault =
        addressListData.indexWhere((element) => element.isDefault == true);
    if (indexDefault > -1) {
      return addressListData[indexDefault];
    } else
      return Address();
  }

  void setDefaultAddress(index) {
    int indexDefault =
        addressList.indexWhere((element) => element.isDefault == true);
    if (indexDefault > -1) {
      addressList[indexDefault].isDefault = false;
    }
    addressList[index].isDefault = true;
    addressList.refresh();
  }
}
