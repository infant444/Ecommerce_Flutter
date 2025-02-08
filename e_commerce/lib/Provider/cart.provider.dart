import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/cart.model.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<QuerySnapshot>? _productSubscription;

  bool isLoading = false;
  List<Cart> carts = [];
  List<String> cartUids = [];
  List<Product> products = [];
  int totalCost = 0;
  int totalQuantity = 0;
  CartProvider() {
    readCartData();
  }
  void addToCart(Cart cartModel) {
    Firestoreservices().addToCart(cartx: cartModel);
    notifyListeners();
  }

  void calculateTotalQuantity() {
    totalQuantity = 0;
    for (int i = 0; i < carts.length; i++) {
      totalQuantity += carts[i].quantity;
    }
    print("Total Quantity: $totalQuantity");
    notifyListeners();
  }

  void readCartData() {
    isLoading = true;
    _cartSubscription?.cancel();
    _cartSubscription = Firestoreservices().readUserCart().listen((snapshot) {
      List<Cart> cartData = Cart.fromJsonList(snapshot.docs) as List<Cart>;
      carts = cartData;
      cartUids = [];
      for (int i = 0; i < carts.length; i++) {
        cartUids.add(carts[i].productId);
      }
      if (carts.length > 0) {
        readCartProduct(cartUids);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  void readCartProduct(List<String> productId) {
    _productSubscription?.cancel();
    _productSubscription =
        Firestoreservices().searchProductS(productId).listen((snapshot) {
      List<Product> productData =
          Product.fromJsonList(snapshot.docs) as List<Product>;
      products = productData;
      isLoading = false;
      calcuateTotalCost(products, carts);
      calculateTotalQuantity();
      notifyListeners();
    });
  }

  void calcuateTotalCost(List<Product> products, List<Cart> carts) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < carts.length; i++) {
        totalCost = carts[i].quantity * products[i].new_price;
      }
      notifyListeners();
    });
  }

  void deleteItem(String ProductId) {
    Firestoreservices().deleteItemFromCart(id: ProductId);
    readCartData();
    notifyListeners();
  }

  void decreaseCount(String productId) {
    Firestoreservices().decreaseCount(productId: productId);
    notifyListeners();
  }
}
