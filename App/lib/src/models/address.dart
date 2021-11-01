class Address {
  final String? title;
  final String? address;
  final double? lat;
  final double? lng;
  bool? isDefault;

  Address({this.title, this.address, this.lat, this.lng, this.isDefault});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "address": address,
      "lat": lat,
      "lng": lng,
      "isDefault": isDefault
    };
  }

  static Address fromJson(dynamic json) {
    return Address(
      title: json['title'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      isDefault: json['isDefault'],
    );
  }
}
