import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/order.model.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  totalQuantityCalculator(List<OrderProduct> product) {
    int qty = 0;
    product.map((e) => qty += e.quentity).toList();
    return qty;
  }

  String symbol = getCurrencySymbol("INR");

  Widget statusIcon(String status) {
    if (status == 'Confirmed') {
      return StatusContainer(
          text: "Confirmed",
          bgColor: Colors.lightGreen,
          textColor: Colors.white);
    } else if (status == 'ON_THE_WAY') {
      return StatusContainer(
          text: "ON THE WAY", bgColor: Colors.yellow, textColor: Colors.black);
    } else if (status == 'DELIVERED') {
      return StatusContainer(
          text: "DELIVERED",
          bgColor: Colors.green.shade700,
          textColor: Colors.white);
    } else {
      return StatusContainer(
          text: "CANCELLED", bgColor: Colors.red, textColor: Colors.white);
    }
  }

  Widget StatusContainer(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<AdminProvider>(builder: (context, value, child) {
        List<OrderModule> orders =
            OrderModule.fromJsonList(value.Order) as List<OrderModule>;
        if (orders.isEmpty) {
          return Center(
            child: Text("Orders not found"),
          );
        } else {
          return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/view_Order",
                        arguments: orders[index]);
                  },
                  title: Text.rich(TextSpan(children: [
                    TextSpan(text: "Order by "),
                    TextSpan(
                        text: orders[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: "\nItems worth "),
                    TextSpan(
                        text: "$symbol ${orders[index].total}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ])),
                  subtitle: Text(
                      "Ordered on ${DateTime.fromMillisecondsSinceEpoch(orders[index].create_at).toString().formattedDate()}"),
                  trailing: statusIcon(orders[index].status),
                );
              });
        }
      }),
    );
  }
}

extension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
