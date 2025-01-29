// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import

import 'package:cloudinary_dart/cloudinary.dart';
import 'package:e_commerce_admin/Component/categories_page.dart';
import 'package:e_commerce_admin/Component/coupon_page.dart';
import 'package:e_commerce_admin/Component/home.dart';
import 'package:e_commerce_admin/Component/login.dart';
import 'package:e_commerce_admin/Component/product_page.dart';
import 'package:e_commerce_admin/Component/promos_banner_page.dart';
import 'package:e_commerce_admin/Component/signup.dart';
import 'package:e_commerce_admin/Component/view_product.dart';
import 'package:e_commerce_admin/controllers/auth_server.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:e_commerce_admin/sub_Component/modify_coupon.dart';
import 'package:e_commerce_admin/sub_Component/modify_product.dart';
import 'package:e_commerce_admin/sub_Component/modify_promo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const Ecommerce_Admin());
}

class Ecommerce_Admin extends StatelessWidget {
  const Ecommerce_Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => CheckUser(),
          "/login": (context) => login(),
          "/signup": (context) => SignUp(),
          "/home": (context) => AdminHome(),
          "/categories": (context) => CategoriesPage(),
          "/products": (context) => ProductPage(),
          "/add-product": (context) => ModifyProduct(),
          "/view-product": (context) => ViewProduct(),
          "/promos": (context) => PromosBannerPage(),
          "/update_promo": (context) => ModifyPromo(),
          "/coupon": (context) => CouponPage(),
          "/update_coupon": (context) => ModifyCoupon(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLogIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
