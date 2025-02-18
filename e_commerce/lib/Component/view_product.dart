import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:e_commerce/Provider/wishlist.provider.dart';
import 'package:e_commerce/model/cart.model.dart';
import 'package:e_commerce/model/wishlit.model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:provider/provider.dart';

import '../model/product.model.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  String symbol = getCurrencySymbol("INR");
  bool x = false;
  Color c = Colors.grey;
  String wid = "";
  abc(String id) async {
    QuerySnapshot querySnapshot =
        await Firestoreservices().readWishlist(productid: id);
    if (querySnapshot.docs.isNotEmpty) {
      if (mounted) {
        // ✅ Check if widget is still in the tree
        setState(() {
          x = true;
          c = Colors.red;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Product;
    y() {
      Map<String, dynamic> data = {"productId": argument.id};

      setState(() {
        if (x) {
          c = Colors.grey;
          Firestoreservices().deleteWishlist(id: argument.id);
        } else {
          Firestoreservices().createWishList(data: data);

          c = Colors.red;
        }
        x = !x;
        print(x);
      });
    }

    abc(argument.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product View"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 310,
                    child: Image.network(
                      argument.image,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 5, // Adjust for positioning
                    right: 5, // Adjust for positioning
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            print(x);
                            y();
                            // abc(argument.id);
                            print(x);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: c,
                            size: 30,
                          ),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      argument.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "$symbol ${argument.old_price}.00",
                          style: TextStyle(
                              color: Colors.grey[700],
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$symbol ${argument.new_price}.00",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_downward_outlined,
                          color: Colors.green,
                          size: 20,
                        ),
                        Text(
                          "${discountPrecent(argument.old_price, argument.new_price)}%",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PannableRatingBar(
                        rate: double.parse(argument.rating.toString()),
                        items: List.generate(
                            5,
                            (index) => const RatingWidget(
                                  selectedColor: Colors.black,
                                  unSelectedColor: Colors.grey,
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                  ),
                                ))),
                    SizedBox(
                      height: 10,
                    ),
                    argument.maxQuantity == 0
                        ? Text(
                            "Out of stock",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          )
                        : argument.maxQuantity <= 10
                            ? Text(
                                "Only ${argument.maxQuantity} left in stock",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange),
                              )
                            : Text(
                                "Only ${argument.maxQuantity} left in stock",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green),
                              ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      argument.description,
                      textAlign: TextAlign.justify,
                      maxLines: 8,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: argument.maxQuantity > 0
          ? Row(
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .5,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Cart(productId: argument.id, quantity: 1));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Added to cart"),
                        action: SnackBarAction(
                            label: "Go to Cart",
                            textColor: Colors.orangeAccent.shade400,
                            onPressed: () {
                              Navigator.pushNamed(context, "/cart");
                            }),
                        dismissDirection: DismissDirection.startToEnd,
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder()),
                    child: Text("Add to Cart"),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .5,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(Cart(productId: argument.id, quantity: 1));
                      Navigator.pushNamed(context, "/checkout");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder()),
                    child: Text("Buy Now"),
                  ),
                )
              ],
            )
          : Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications),
                          Text(
                            "Notify Me",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ))
                ],
              ),
            ),
    );
  }
}
