import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  String sc = "shop_Categories";
  String product = "shop_Product";
  String promo = "shop_Promos";
  String banner = "shop_Banner";
  String coupon = "Shop_Coupon";
  // read data from shop_Categories collection of firestore
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection(sc)
        .orderBy("priority", descending: true)
        .snapshots();
  }

  // write data to shop_Categories collection of firestore
  Future createCategories({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(sc).add(data);
  }

  //update data

  Future updateCategories(
      {required String id, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(sc).doc(id).update(data);
  }

  Future deleteCategories({
    required String id,
  }) async {
    await FirebaseFirestore.instance.collection(sc).doc(id).delete();
  }

//products
  Stream<QuerySnapshot> readProduct() {
    return FirebaseFirestore.instance
        .collection(product)
        .orderBy("category", descending: true)
        .snapshots();
  }

  Future createProduct({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(product).add(data);
  }

  Future updateProduct(
      {required String id, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(product).doc(id).update(data);
  }

  Future deleteProduct({
    required String id,
  }) async {
    await FirebaseFirestore.instance.collection(product).doc(id).delete();
  }

  //Promos and banner

  Stream<QuerySnapshot> readPromos(bool isPromo) {
    return FirebaseFirestore.instance
        .collection(isPromo ? promo : banner)
        .snapshots();
  }

  Future createPromo(
      {required Map<String, dynamic> data, required bool isPromo}) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? promo : banner)
        .add(data);
  }

  Future updatePromo(
      {required String id,
      required Map<String, dynamic> data,
      required bool isPromo}) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? promo : banner)
        .doc(id)
        .update(data);
  }

  Future deletePromo({required String id, required bool isPromo}) async {
    await FirebaseFirestore.instance
        .collection(isPromo ? promo : banner)
        .doc(id)
        .delete();
  }
  // Coupon

  Stream<QuerySnapshot> readCouponCode() {
    return FirebaseFirestore.instance.collection(coupon).snapshots();
  }

  Future createCouponCode({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(coupon).add(data);
  }

  Future updateCouponCode(
      {required String id, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection(coupon).doc(id).update(data);
  }

  Future deleteCouponCode({
    required String id,
  }) async {
    await FirebaseFirestore.instance.collection(coupon).doc(id).delete();
  }
}
