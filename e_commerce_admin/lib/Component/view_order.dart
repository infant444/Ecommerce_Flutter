import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce_admin/container/additional_confirm.dart';
import 'package:e_commerce_admin/container/order_status.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/order.model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.model.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  String symbol = getCurrencySymbol("INR");

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as OrderModule;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Delivery Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.blueGrey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Order Id : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text: "#${arg.id}", style: TextStyle(fontSize: 16))
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Order On : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text:
                              DateTime.fromMillisecondsSinceEpoch(arg.create_at)
                                  .toString()
                                  .formattedDate(),
                          style: TextStyle(fontSize: 16))
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Order by : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(text: arg.name, style: TextStyle(fontSize: 16))
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Phone no : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(text: arg.phone, style: TextStyle(fontSize: 16))
                    ])),
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Delivery Address : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                          text: arg.address, style: TextStyle(fontSize: 16))
                    ])),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: arg.products
                    .map((e) => Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      List<String> a = [];
                                      a.add(e.id);
                                      FirestoreServices()
                                          .searchProductS(a)
                                          .listen((snapshot) {
                                        List<Product> productData =
                                            Product.fromJsonList(snapshot.docs)
                                                as List<Product>;
                                        Navigator.pushNamed(
                                            context, "/view_Product",
                                            arguments: productData[0]);
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Image.network(e.image),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(child: Text(e.name)),
                                ],
                              ),
                              Text(
                                "$symbol${e.single_price.toString()} x ${e.quentity} quantity",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$symbol${e.total_price}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    arg.discount > 0
                        ? Text(
                            "Discount : $symbol${arg.discount}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )
                        : SizedBox(),
                    Text(
                      "Total : $symbol${arg.total}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "Status : ${arg.status}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 400,
                child: OrderStatus(
                    status: arg.status,
                    create_at: arg.create_at,
                    receivedDate: arg.receivedDate,
                    onTheWayDate: arg.onTheWayDate),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .75,
                  child: ElevatedButton(
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black38.withOpacity(0.5),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15))),
                            builder: (context) => Container(
                                  height: 300,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(13),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Modify this order",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Choose what you want set",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await FirestoreServices()
                                                .UpdateOrderStatus(
                                                    docId: arg.id,
                                                    data: "ON_THE_WAY");
                                            setState(() {});
                                          },
                                          child: Text("Order Shipped")),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await FirestoreServices()
                                                .UpdateOrderStatus(
                                                    docId: arg.id,
                                                    data: "DELIVERED");
                                            setState(() {});
                                          },
                                          child: Text("Order Delivery")),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await FirestoreServices()
                                                .UpdateOrderStatus(
                                                    docId: arg.id,
                                                    data: "CANCELLED");
                                            setState(() {});
                                          },
                                          child: Text("Order Cancel")),
                                    ],
                                  ),
                                ));
                      },
                      child: Text("Modified order")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
