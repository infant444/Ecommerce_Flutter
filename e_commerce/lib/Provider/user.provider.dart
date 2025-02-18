import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/user.model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _UserSubscription;
  String name = "";
  String email = "";
  String address = "";
  String phone = "";
  String profile = "";
  UserProvider() {
    loadUserData();
  }
  void loadUserData() {
    _UserSubscription?.cancel();
    _UserSubscription = Firestoreservices().readUserData().listen((snapShot) {
      print(snapShot.data());
      final UserModel data =
          UserModel.formJson(snapShot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      profile = data.profile;
      notifyListeners();
    });
  }

  void cancelProvider() {
    _UserSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
