import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/wishlit.model.dart';
import 'package:flutter/foundation.dart';

class RatingModel {
  final String id;
  final String name;
  final String productId;
  final rating;
  final String review;
  final String emoji;
  RatingModel(
      {required this.id,
      required this.name,
      required this.productId,
      required this.rating,
      required this.review,
      required this.emoji});
  factory RatingModel.fromjson(Map<String, dynamic> json, String id) {
    return RatingModel(
        id: id,
        name: json["name"] ?? "",
        productId: json["productId"] ?? "",
        rating: json["rating"] ?? 0,
        review: json["review"] ?? "",
        emoji: json["emoji"] ?? "");
  }
  static List<Wishlist> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Wishlist.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
