import 'package:e_commerce/Container/category_container.dart';
import 'package:e_commerce/Container/discount_container.dart';
import 'package:e_commerce/Container/home_page_make_container.dart';
import 'package:e_commerce/Container/promo_container.dart';
import 'package:e_commerce/Controllers/Flutter_notification.dart';
import 'package:e_commerce/Controllers/auth_server.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Best Deals"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/wishlist");
                },
                icon: Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {
                  LocalNotification.showSimpleNotification(
                      title: "IR shopping",
                      body: "Your order is received",
                      payload: "This is simple data");
                },
                icon: Icon(Icons.notifications_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PromoContainer(),
              DiscountContainer(),
              CategoryContainer(),
              HomePageMakeContainer()
            ],
          ),
        ));
  }
}
