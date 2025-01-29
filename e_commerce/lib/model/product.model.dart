import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String description;
  String image;
  String category;
  int old_price;
  int new_price;
  int rating;
  int maxQuantity;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.category,
      required this.old_price,
      required this.new_price,
      required this.rating,
      required this.maxQuantity});

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
        id: id,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        image: json["image"] ?? "",
        category: json["category"] ?? "",
        old_price: json["old_price"] ?? 0,
        new_price: json["new_price"] ?? 0,
        rating: json["rating"] ?? 0,
        maxQuantity: json["maxQuantity"] ?? 0);
  }
  static List<Product> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Product.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
