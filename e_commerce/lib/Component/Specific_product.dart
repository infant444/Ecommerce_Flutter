import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:flutter/material.dart';

class SpecificProduct extends StatefulWidget {
  const SpecificProduct({super.key});

  @override
  State<SpecificProduct> createState() => _SpecificProductState();
}

class _SpecificProductState extends State<SpecificProduct> {
  String symbol = getCurrencySymbol("INR");

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)}"),
      ),
      body: StreamBuilder(
          stream: Firestoreservices().readProduct(args["name"]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products =
                  Product.fromJsonList(snapshot.data!.docs) as List<Product>;
              if (products.isEmpty) {
                return Center(
                  child: Text("No product is found"),
                );
              } else {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/view_Product",
                              arguments: product);
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            product.image,
                                          ),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    "$symbol${product.old_price}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "$symbol${product.new_price}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  Text(
                                    "${discountPrecent(product.old_price, product.new_price)}%",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
