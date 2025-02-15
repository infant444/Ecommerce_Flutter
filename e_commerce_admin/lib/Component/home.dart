// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_commerce_admin/container/dashboard_button.dart';
import 'package:e_commerce_admin/container/dashboard_text.dart';
import 'package:e_commerce_admin/controllers/auth_server.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Consumer<AdminProvider>(builder: (context, value, child) {
        int total_product = value.totalProducts;
        int total_categories = value.totalCategories;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 240,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashBoardText(
                          keyWord: "Total Products",
                          value: total_product.toString()),
                      DashBoardText(
                          keyWord: "Total Categories",
                          value: total_categories.toString()),
                      DashBoardText(keyWord: "abc", value: "Hello"),
                      DashBoardText(keyWord: "abc", value: "Hello"),
                      DashBoardText(keyWord: "abc", value: "Hello"),
                    ],
                  )),
              Row(
                children: [
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/order");
                      },
                      name: "Orders"),
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/products");
                      },
                      name: "Product"),
                ],
              ),
              Row(
                children: [
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/promos",
                            arguments: {"Promo": true});
                      },
                      name: "Promos"),
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/promos",
                            arguments: {"Promo": false});
                      },
                      name: "Banner"),
                ],
              ),
              Row(
                children: [
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/categories");
                      },
                      name: "Categories"),
                  DashboardButton(
                      ontap: () {
                        Navigator.pushNamed(context, "/coupon");
                      },
                      name: "Coupons"),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
