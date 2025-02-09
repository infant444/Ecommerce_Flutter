import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Container/cart_container.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String symbol = getCurrencySymbol("INR");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<CartProvider>(builder: (context, value, child) {
        if (value.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (value.carts.isEmpty || value.products.isEmpty) {
            return Center(
              child: Text("No item in cart"),
            );
          } else {
            return ListView.builder(
                itemCount: value.carts.length,
                itemBuilder: (context, index) {
                  return CartContainer(
                      product: value.products[index],
                      selectedQuentity: value.carts[index].quantity);
                });
          }
        }
      }),
      bottomNavigationBar:
          Consumer<CartProvider>(builder: (context, value, child) {
        if (value.carts.length == 0) {
          return SizedBox();
        } else {
          return Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total : $symbol${value.totalCost}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/checkout");
                  },
                  child: Text("Process to Checkout"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
