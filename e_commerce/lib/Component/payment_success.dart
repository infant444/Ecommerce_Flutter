import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/order.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  String symbol = getCurrencySymbol("INR");
  int calgst(int x) {
    return (0.018 * x).round();
  }

  @override
  Widget build(BuildContext context) {
    final argu =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Successful"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: LottieBuilder.asset(
                    "asset/lottie/success.json",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "The order placed Successfully",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your order has been confirmed and will be delivered soon",
                textAlign: TextAlign.center,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Detail",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Order id"),
                        Spacer(),
                        Text("#${argu["id"]}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Order date"),
                        Spacer(),
                        Text(
                            "${DateTime.fromMillisecondsSinceEpoch(argu["create_at"]).toString().formattedDate()}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Total amount"),
                        Spacer(),
                        Text("$symbol${(argu["total"] - argu["discount"])}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Order status"),
                        Spacer(),
                        Text(
                          "${argu["status"]}",
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Detail",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Address",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                argu["address"],
                                overflow: TextOverflow.visible,
                                maxLines: 4,
                                softWrap: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Method",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Express Delivery Within (2-3 days)",
                                overflow: TextOverflow.visible,
                                maxLines: 4,
                                softWrap: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Detail",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.payment_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Method",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade800,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Razorpay ",
                                  overflow: TextOverflow.visible,
                                  maxLines: 4,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ]),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Total"),
                        Spacer(),
                        Text("$symbol${argu["total"] - calgst(argu["total"])}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Discount"),
                        Spacer(),
                        Text("- $symbol${argu["discount"]}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("GST 18% tax"),
                        Spacer(),
                        Text("$symbol${calgst(argu["total"])}"),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text("Total amount"),
                        Spacer(),
                        Text(
                          "${argu["total"] - argu["discount"]}",
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    )
                  ],
                ),
              ),
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/home");
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder()),
              child: Text("Continue shopping"),
            ),
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * .5,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/order");
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder()),
              child: Text("Track order"),
            ),
          )
        ],
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
