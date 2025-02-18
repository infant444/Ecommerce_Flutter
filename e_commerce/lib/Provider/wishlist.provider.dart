// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_commerce/Controllers/firestoreServices.dart';
// import 'package:e_commerce/model/product.model.dart';
// import 'package:e_commerce/model/wishlit.model.dart';
// import 'package:flutter/material.dart';

// class WishlistProvider extends ChangeNotifier {
//   StreamSubscription<QuerySnapshot>? _wishlistSubscription;
//   StreamSubscription<QuerySnapshot>? _ProductSubscription;
//   List<Wishlist> wish = [];
//   List<Product> product = [];
//   List<String> id = [];
//   WishlistProvider() {
//     readWishData();
//   }
//   void readWishData() {
//     _wishlistSubscription?.cancel();
//     _wishlistSubscription =
//         Firestoreservices().readallWishList().listen((snapshot) {
//       print("object khbhjb");
//       List<Wishlist> WishData =
//           Wishlist.fromJsonList(snapshot.docs) as List<Wishlist>;

//       wish = wish;

//       id = [];
//       for (int i = 0; i < wish.length; i++) {
//         print(wish[i].productId);

//         id.add(wish[i].productId);
//         print(id);
//       }
//       if (wish.isNotEmpty) {
//         readWishProduct(id);
//       }
//       notifyListeners();
//     });
//   }

//   readWishProduct(List<String> productId) {
//     _ProductSubscription?.cancel();
//     _ProductSubscription =
//         Firestoreservices().searchProductS(productId).listen((snapShot) {
//       List<Product> productData =
//           Product.fromJsonList(snapShot.docs) as List<Product>;
//       product = productData;
//       notifyListeners();
//     });
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:e_commerce/model/wishlit.model.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _wishlistSubscription;
  StreamSubscription<QuerySnapshot>? _ProductSubscription;
  List<Wishlist> wish = [];
  List<Product> product = [];
  List<String> id = [];

  WishlistProvider() {
    readWishData();
  }

  void readWishData() {
    _wishlistSubscription?.cancel();
    _wishlistSubscription =
        Firestoreservices().readallWishList().listen((snapshot) {
      List<Wishlist> WishData = Wishlist.fromJsonList(snapshot.docs) ?? [];

      wish = WishData; // Fixed assignment

      if (wish.isNotEmpty) {
        id = wish.map((w) => w.productId).toList(); // Optimized id assignment
        print(id);
        readWishProduct(id);
      } else {
        print("Wishlist is empty");
      }

      notifyListeners();
    });
  }

  void readWishProduct(List<String> productId) {
    if (productId.isEmpty) return; // Prevent querying with empty list

    _ProductSubscription?.cancel();
    _ProductSubscription =
        Firestoreservices().searchProductS(productId).listen((snapShot) {
      product = Product.fromJsonList(snapShot.docs) ?? [];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _wishlistSubscription?.cancel();
    _ProductSubscription?.cancel();
    super.dispose();
  }
}
