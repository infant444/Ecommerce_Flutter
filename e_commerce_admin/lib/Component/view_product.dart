import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce_admin/controllers/discount.dart';
import 'package:e_commerce_admin/model/product.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  String symbol = getCurrencySymbol("INR");

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text("User's View"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                argument.image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
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
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * .5,
            child: ElevatedButton(
              onPressed: () {},
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder()),
              child: Text("Buy Now"),
            ),
          )
        ],
      ),
    );
  }
}
