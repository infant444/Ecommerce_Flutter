import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/cart.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestoreservices {
  User? user = FirebaseAuth.instance.currentUser;
  String use = "Users";
  String banner = "shop_Banner";
  String promo = "shop_Promos";
  String coupon = "Shop_Coupon";
  String category = "shop_Categories";
  String product = "shop_Product";
  String su = "shop_user";
  String cart = "cart";

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
// Verify coupon

  Future<QuerySnapshot> verifyCoupon({required String code}) {
    return FirebaseFirestore.instance
        .collection(coupon)
        .where("code", isEqualTo: code)
        .get();
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

// search product by using id
  Stream<QuerySnapshot> searchProductS(List<String> docIds) {
    return FirebaseFirestore.instance
        .collection(product)
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  // Read the Cart
  Stream<QuerySnapshot> readUserCart() {
    return FirebaseFirestore.instance
        .collection(su)
        .doc(user!.uid)
        .collection(cart)
        .snapshots();
  }

  Future addToCart({required Cart cartx}) async {
    try {
      await FirebaseFirestore.instance
          .collection(su)
          .doc(user!.uid)
          .collection(cart)
          .doc(cartx.productId)
          .update({
        "productId": cartx.productId,
        "quantity": FieldValue.increment(1)
      });
    } on FirebaseException catch (e) {
      print("Firebase exception : ${e.code}");
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection(su)
            .doc(user!.uid)
            .collection(cart)
            .doc(cartx.productId)
            .set({"productId": cartx.productId, "quantity": cartx.quantity});
      }
    }
  }

  Future deleteItemFromCart({required String id}) async {
    await FirebaseFirestore.instance
        .collection(su)
        .doc(user!.uid)
        .collection(cart)
        .doc(id)
        .delete();
  }

  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection(su)
        .doc(user!.uid)
        .collection(cart)
        .get()
        .then((v) {
      for (DocumentSnapshot ds in v.docs) {
        ds.reference.delete();
      }
    });
  }

  Future decreaseCount({required String productId}) async {
    await FirebaseFirestore.instance
        .collection(su)
        .doc(user!.uid)
        .collection(cart)
        .doc(productId)
        .update({"quantity": FieldValue.increment(-1)});
  }
}
