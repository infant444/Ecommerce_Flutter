import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModule {
  String id, email, name, phone, status, user_id, address, paymentUrl;
  int discount, total, create_at, receivedDate, onTheWayDate;
  List<OrderProduct> products;
  OrderModule(
      {required this.id,
      required this.email,
      required this.name,
      required this.phone,
      required this.status,
      required this.user_id,
      required this.address,
      required this.discount,
      required this.total,
      required this.create_at,
      required this.receivedDate,
      required this.onTheWayDate,
      required this.paymentUrl,
      required this.products});
  factory OrderModule.fromJson(Map<String, dynamic> json, String id) {
    return OrderModule(
      id: id ?? "",
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      status: json["status"] ?? "",
      user_id: json["user_id"] ?? "",
      address: json["address"] ?? "",
      paymentUrl: json["paymentUrl"] ?? "",
      discount: json["discount"] ?? 0,
      total: json["total"] ?? 0,
      create_at: json["create_at"] ?? 0,
      receivedDate: json["receivedDate"] ?? 0,
      onTheWayDate: json["onTheWayDate"] ?? 0,
      products: List<OrderProduct>.from(
          json["products"].map((e) => OrderProduct.fromJson(e))),
    );
  }
  static List<OrderModule> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => OrderModule.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}

class OrderProduct {
  String id, name, image;
  int quentity, single_price, total_price;
  OrderProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.quentity,
    required this.single_price,
    required this.total_price,
  });
  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        quentity: json["quentity"] ?? 0,
        single_price: json["single_price"] ?? 0,
        total_price: json["total_price"] ?? 0);
  }
}
