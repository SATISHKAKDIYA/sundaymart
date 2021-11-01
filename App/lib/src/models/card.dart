class Card {
  final String? name;
  final String? cardNumber;
  final String? expireDate;
  final String? cvc;
  final int? type;
  Card({this.name, this.cvc, this.cardNumber, this.expireDate, this.type = 0});
}
