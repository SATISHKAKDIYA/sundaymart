class Banner {
  final int? id;
  final String? title;
  final String? subTitle;
  final String? imageUrl;
  final String? titleColor;
  final String? backColor;
  final String? buttonColor;
  final int? position;
  final String? buttonText;
  final String? buttonTextColor;
  final String? description;

  Banner(
      {this.id,
      this.backColor,
      this.buttonColor,
      this.buttonText,
      this.buttonTextColor,
      this.description,
      this.imageUrl,
      this.position,
      this.title,
      this.subTitle,
      this.titleColor});
}
