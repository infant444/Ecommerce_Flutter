import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestoreservices {
  User? user = FirebaseAuth.instance.currentUser;
  String use = "Users";
  String banner = "shop_Banner";
  String promo = "shop_Promos";
  String coupon = "Shop_Coupon";
  String category = "shop_Categories";
  String product = "shop_Product";

  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {"name": name, "email": email};
      await FirebaseFirestore.instance.collection(use).doc(user!.uid).set(data);
    } catch (e) {
      print("erroe on saving user data:$e");
    }
  }

  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection(use)
        .doc(user!.uid)
        .update(extraData);
  }

  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection(use)
        .doc(user!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection(promo).snapshots();
  }

  Stream<QuerySnapshot> readBanner() {
    return FirebaseFirestore.instance.collection(banner).snapshots();
  }

  Stream<QuerySnapshot> readDiscount() {
    return FirebaseFirestore.instance
        .collection(coupon)
        .orderBy("discount", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> readCategory() {
    return FirebaseFirestore.instance
        .collection(category)
        .orderBy("priority", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> readProduct(String category) {
    return FirebaseFirestore.instance
        .collection(product)
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }
}
