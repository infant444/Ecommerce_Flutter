// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscription;
  List<QueryDocumentSnapshot> Product = [];
  StreamSubscription<QuerySnapshot>? _productSubscription;
  List<QueryDocumentSnapshot> Order = [];
  StreamSubscription<QuerySnapshot>? _orderSubscription;
  List<QueryDocumentSnapshot> User = [];
  StreamSubscription<QuerySnapshot>? _userSubscription;
  int totalCategories = 0;
  int totalProducts = 0;
  int totalOrder = 0;
  int totalOrderDelivery = 0;
  int totalOrderShipped = 0;
  int totalOrderCancelled = 0;
  int totalOrderProcess = 0;
  int totalUser = 0;
  AdminProvider() {
    getCategories();
    getProduct();
    getOrder();
    getUser();
  }

  void getCategories() {
    _categorySubscription?.cancel();
    _categorySubscription =
        FirestoreServices().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories = snapshot.docs.length;
      notifyListeners();
    });
  }

  void getProduct() {
    _productSubscription?.cancel();
    _productSubscription = FirestoreServices().readProduct().listen((snapshot) {
      Product = snapshot.docs;
      totalProducts = snapshot.docs.length;
      notifyListeners();
    });
  }

  void getOrder() {
    _orderSubscription?.cancel();
    _productSubscription = FirestoreServices().readOrders().listen((onData) {
      Order = onData.docs;
      totalOrder = onData.docs.length;
      serOrderStatusCount();
    });

    notifyListeners();
  }

  void serOrderStatusCount() {
    totalOrderDelivery = 0;
    totalOrderShipped = 0;
    totalOrderCancelled = 0;
    for (int i = 0; i < Order.length; i++) {
      if (Order[i]["status"] == "DELIVERED") {
        totalOrderDelivery++;
      } else if (Order[i]["status"] == "CANCELLED") {
        totalOrderCancelled++;
      } else if (Order[i]["status"] == "ON_THE_WAY") {
        totalOrderShipped++;
      } else {
        totalOrderProcess++;
      }
    }
    notifyListeners();
  }

  getUser() {
    _userSubscription?.cancel();
    _userSubscription = FirestoreServices().readUserData().listen((onData) {
      User = onData.docs;
      totalUser = onData.docs.length;
    });
    notifyListeners();
  }

  void cancelProvider() {
    _categorySubscription?.cancel();
    _productSubscription?.cancel();
    _orderSubscription?.cancel();
    _userSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
