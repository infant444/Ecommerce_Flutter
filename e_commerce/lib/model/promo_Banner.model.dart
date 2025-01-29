import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBanner {
  final String id;
  final String title;
  final String category;
  final String image;
  PromoBanner({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
  });
  factory PromoBanner.fromJson(Map<String, dynamic> json, String id) {
    return PromoBanner(
        title: json["title"] ?? "",
        image: json["image"] ?? "",
        category: json["category"] ?? "",
        id: id);
  }

  static List<PromoBanner> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => PromoBanner.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
