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
  WishlistProvider() {}
  void readWishData() {
    _wishlistSubscription?.cancel();
    _wishlistSubscription =
        Firestoreservices().readallWishList().listen((snapshot) {
      List<Wishlist> WishData =
          Wishlist.fromJsonList(snapshot.docs) as List<Wishlist>;
      wish = wish;
      id = [];
      for (int i = 0; i < wish.length; i++) {
        id.add(wish[i].productId);
      }
      if (wish.isNotEmpty) {
        readWishProduct(id);
      }
      notifyListeners();
    });
  }

  readWishProduct(List<String> productId) {
    _ProductSubscription?.cancel();
    _ProductSubscription =
        Firestoreservices().searchProductS(productId).listen((snapShot) {
      List<Product> productData =
          Product.fromJsonList(snapShot.docs) as List<Product>;
      product = productData;
      notifyListeners();
    });
  }
}
