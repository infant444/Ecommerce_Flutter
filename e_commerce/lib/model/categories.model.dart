import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String name;
  String img;
  int priority;

  Category(
      {required this.id,
      required this.name,
      required this.img,
      required this.priority});

  // convert json to object model
  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
        id: id,
        name: json["name"] ?? "",
        img: json["img"] ?? "",
        priority: json["priority"] ?? 0);
  }

  static List<Category> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Category.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
