import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/order.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      color: bgColor,
      padding: EdgeInsets.all(8),
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
      body: StreamBuilder(
          stream: Firestoreservices().readOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModule> orders =
                  OrderModule.fromJsonList(snapshot.data!.docs)
                      as List<OrderModule>;
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
                        title: Text(
                            "${totalQuantityCalculator(orders[index].products)} items worth $symbol ${orders[index].total}"),
                        subtitle: Text(
                            "Ordered on ${DateTime.fromMillisecondsSinceEpoch(orders[index].create_at).toString().formattedDate()}"),
                        trailing: statusIcon(orders[index].status),
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
