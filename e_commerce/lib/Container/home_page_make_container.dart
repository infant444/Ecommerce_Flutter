import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Container/banner_container.dart';
import 'package:e_commerce/Container/category_container.dart';
import 'package:e_commerce/Container/zone_container.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/categories.model.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:e_commerce/model/promo_Banner.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageMakeContainer extends StatefulWidget {
  const HomePageMakeContainer({super.key});

  @override
  State<HomePageMakeContainer> createState() => _HomePageMakeContainerState();
}

class _HomePageMakeContainerState extends State<HomePageMakeContainer> {
  int min = 0;
  minCalculator(int a, int b) {
    return min = a < b ? a : b;
  }

  String symbol = getCurrencySymbol("INR");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestoreservices().readCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> category =
                Category.fromJsonList(snapshot.data!.docs) as List<Category>;
            if (category.isEmpty) {
              return SizedBox();
            } else {
              return StreamBuilder(
                  stream: Firestoreservices().readBanner(),
                  builder: (context, banner_snapshot) {
                    if (banner_snapshot.hasData) {
                      List<PromoBanner> banner =
                          PromoBanner.fromJsonList(banner_snapshot.data!.docs)
                              as List<PromoBanner>;
                      if (banner.isEmpty) {
                        return SizedBox();
                      } else {
                        return Column(
                          children: [
                            for (int i = 0;
                                i <
                                    minCalculator(snapshot.data!.docs.length,
                                        banner_snapshot.data!.docs.length);
                                i++)
                              Column(
                                children: [
                                  ZoneContainer(
                                      Category: snapshot.data!.docs[i]["name"]),
                                  BannerContainer(
                                      image: banner_snapshot.data!.docs[i]
                                          ["image"],
                                      category: banner_snapshot.data!.docs[i]
                                          ["category"])
                                ],
                              )
                          ],
                        );
                      }
                    } else {
                      return SizedBox();
                    }
                  });
            }
          } else {
            return Shimmer(
              // ignore: sized_box_for_whitespace, sort_child_properties_last
              child: Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey.shade200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    ],
                  ),
                ),
              ),
              period: Duration(seconds: 9),
              gradient: LinearGradient(colors: [
                Colors.grey.shade100,
                Colors.grey,
                Colors.grey.shade100
              ]),
              direction: ShimmerDirection.ltr,
            );
          }
        });
  }
}
