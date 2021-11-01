class Extra {
  final int? id;
  final int? type;
  final double? price;
  final String? name;

  Extra({this.id, this.price, this.type, this.name});

  Map<String, dynamic> toJson() {
    return {"id": id, "price": price};
  }
}
