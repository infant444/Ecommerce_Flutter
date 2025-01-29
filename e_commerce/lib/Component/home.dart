import 'package:e_commerce/Container/category_container.dart';
import 'package:e_commerce/Container/discount_container.dart';
import 'package:e_commerce/Container/promo_container.dart';
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
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PromoContainer(),
              DiscountContainer(),
              CategoryContainer()
            ],
          ),
        ));
  }
}
