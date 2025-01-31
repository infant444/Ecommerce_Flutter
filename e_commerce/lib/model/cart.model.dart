import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String productId;
  int quantity;
  Cart({required this.productId, required this.quantity});
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        productId: json["productId"] ?? '', quantity: json["quantity"] ?? 0);
  }
  static List<Cart> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Cart.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
