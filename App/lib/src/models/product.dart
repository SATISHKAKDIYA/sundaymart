import 'package:githubit/src/models/extra.dart';

class Product {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final double? price;
  double? rating;
  final List<dynamic>? images;
  final double? discount;
  final int? discountType;
  final int? isCountDown;
  final bool? hasCoupon;
  int? reviewCount;
  final String? unit;
  final int? amount;
  int? count;
  List<Extra>? extras;
  int? startTime;
  int? endTime;

  Product(
      {this.id,
      this.hasCoupon = false,
      this.name,
      this.description,
      this.image,
      this.price,
      this.discount,
      this.discountType,
      this.images,
      this.isCountDown = 0,
      this.rating,
      this.reviewCount,
      this.unit,
      this.amount,
      this.count = 0,
      this.startTime,
      this.endTime,
      this.extras});

  Map<String, dynamic> toJson() {
    double discountPrice = 0;
    if (discountType == 1)
      discountPrice = (price! * discount!) / 100;
    else if (discountType == 2) discountPrice = price! - discount!;

    return {
      "id": id,
      "count": count,
      "price": price,
      "discount": discountPrice,
      "extras": extras != null ? extras!.map((e) => e.toJson()).toList() : []
    };
  }
}
