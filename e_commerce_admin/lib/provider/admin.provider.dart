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
  int totalCategories = 0;
  int totalProducts = 0;
  AdminProvider() {
    getCategories();
    getProduct();
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
}
