import 'package:cloud_firestore/cloud_firestore.dart';

class Wishlist {
  final String id;
  final String productId;
  Wishlist({
    required this.id,
    required this.productId,
  });
  factory Wishlist.fromJson(Map<String, dynamic> json, String id) {
    return Wishlist(productId: json["productId"] ?? "", id: id);
  }

  static List<Wishlist> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Wishlist.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
