import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:e_commerce/model/cart.model.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartContainer extends StatefulWidget {
  final Product product;
  final int selectedQuentity;

  const CartContainer(
      {super.key, required this.product, required this.selectedQuentity});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;
  String symbol = getCurrencySymbol("INR");

  increaseCount(int max) async {
    if (count >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum Quantity reached")),
      );
    } else {
      Provider.of<CartProvider>(context, listen: false)
          .addToCart(Cart(productId: widget.product.id, quantity: count));
      setState(() {
        count++;
      });
    }
  }

  decreaseCount() async {
    if (count > 1) {
      Provider.of<CartProvider>(context, listen: false)
          .decreaseCount(widget.product.id);
      setState(() {
        count--;
      });
    } else {
      Provider.of<CartProvider>(context, listen: false)
          .deleteItem(widget.product.id);
      setState(() {});
    }
  }

  @override
  void initState() {
    count = widget.selectedQuentity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/view_Product",
                        arguments: widget.product);
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      widget.product.maxQuantity > 0
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "$symbol ${widget.product.old_price}.00",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "$symbol ${widget.product.new_price}.00",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_downward_outlined,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text(
                                  "${discountPrecent(widget.product.old_price, widget.product.new_price)}%",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Out of stock",
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/specific",
                                          arguments: {
                                            "name": widget.product.category
                                          });
                                    },
                                    child: Text("View smiler product"))
                              ],
                            )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .deleteItem(widget.product.id);
                    },
                    icon: Icon(
                      Icons.delete_outline_sharp,
                      color: Colors.red,
                    ))
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey.shade300),
                  child: IconButton(
                      onPressed: () async {
                        increaseCount(widget.product.maxQuantity);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 16,
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.selectedQuentity}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey.shade300),
                  child: IconButton(
                      onPressed: () async {
                        decreaseCount();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.remove,
                        size: 16,
                      )),
                ),
                Spacer(),
                Text("Total"),
                SizedBox(
                  width: 5,
                ),
                Text("$symbol${widget.product.new_price * count}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
              ],
            )
          ],
        ),
      ),
    );
  }
}
