import 'package:githubit/src/models/brand.dart';

class BrandCategory {
  final int? id;
  final String? name;
  bool? hasLimit;
  List<Brand>? children;

  BrandCategory(
      {this.id, this.name, this.hasLimit = true, this.children = const []});
}
