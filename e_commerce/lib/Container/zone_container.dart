import 'dart:math';

import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ZoneContainer extends StatefulWidget {
  final String Category;
  const ZoneContainer({super.key, required this.Category});

  @override
  State<ZoneContainer> createState() => _ZoneContainerState();
}

class _ZoneContainerState extends State<ZoneContainer> {
  String symbol = getCurrencySymbol("INR");

  Widget SpecialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);
    List<String> quote = ["Start ar $symbol$price", "Get upto $dis% off"];
    return Text(quote[random], style: TextStyle(color: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestoreservices().readProduct(widget.Category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Product> product =
                Product.fromJsonList(snapshot.data!.docs) as List<Product>;
            if (product.isEmpty) {
              return Center(
                child: Text("No product found"),
              );
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 7),
                color: Colors.green.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            " ${widget.Category.substring(0, 1).toUpperCase()}${widget.Category.substring(1)}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/specific",
                                  arguments: {"name": widget.Category});
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ))
                      ],
                    ),
                    Wrap(
                      spacing: 4,
                      children: [
                        for (int i = 0;
                            i < (product.length > 4 ? 4 : product.length);
                            i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/view_Product",
                                  arguments: product[i]);
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * .43,
                              padding: EdgeInsets.all(10),
                              color: Colors.white,
                              height: 180,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.network(
                                      product[i].image,
                                      height: 120,
                                    ),
                                  ),
                                  Text(
                                    product[i].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SpecialQuote(
                                      price: product[i].new_price,
                                      dis: int.parse(discountPrecent(
                                          product[i].old_price,
                                          product[i].new_price)))
                                ],
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Shimmer(
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.grey.shade200, Colors.white])),
            );
          }
        });
  }
}
