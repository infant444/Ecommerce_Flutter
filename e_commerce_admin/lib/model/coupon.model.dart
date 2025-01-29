import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  String id;
  String code;
  int discount;
  String desc;
  int min_amount;
  Coupon({
    required this.id,
    required this.code,
    required this.discount,
    required this.desc,
    required this.min_amount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json, String id) {
    return Coupon(
        id: id,
        code: json["code"] ?? "",
        discount: json["discount"] ?? 0,
        desc: json["desc"] ?? "",
        min_amount: json["min_amount"] ?? 0);
  }
  static List<Coupon> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => Coupon.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
