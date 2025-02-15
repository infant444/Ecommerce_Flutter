import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/auth_server.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:e_commerce/Provider/user.provider.dart';
import 'package:e_commerce/model/order.model.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController _couponConstoller = TextEditingController();
  int discount = 0;
  int toPay = 0;
  String discountText = "";
  DiscountCaluclator(int disPercent, int totalCost) {
    discount = (disPercent * totalCost) ~/ 100;
    setState(() {});
  }

  String symbol = getCurrencySymbol("INR");
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Payment Failed!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    User? CurrentUser = FirebaseAuth.instance.currentUser;
    List product = [];
    for (int i = 0; i < cart.products.length; i++) {
      product.add({
        "id": cart.products[i].id,
        "name": cart.products[i].name,
        "image": cart.products[i].image,
        "quentity": cart.carts[i].quantity,
        "single_price": cart.products[i].new_price,
        "total_price": cart.products[i].new_price * cart.carts[i].quantity
      });
    }
    // ORDER STATUS
    // PAID - Paid money by user
    // SHIPPED - item shipped
    // CANCELED - item cancelled
    // DELIVERY - order delivery
    // RETURN - return order
    Map<String, dynamic> orderdata = {
      "email": user.email,
      "name": user.name,
      "phone": user.phone,
      "status": "Confirmed",
      "user_id": CurrentUser!.uid,
      "address": user.address,
      "discount": discount,
      "total": cart.totalCost - discount,
      "paymentUrl": response.paymentId,
      "products": product,
      "create_at": DateTime.now().millisecondsSinceEpoch,
      "receivedDate": 0,
      "onTheWayDate": 0
    };
    final x = await Firestoreservices().CreateOrder(data: orderdata);
    for (int i = 0; i < cart.products.length; i++) {
      Firestoreservices().reduceQuentity(
          ProductId: cart.products[i].id, quantity: cart.carts[i].quantity);
    }
    Map<String, dynamic> orderdata1 = {
      "id": x,
      "email": user.email,
      "name": user.name,
      "phone": user.phone,
      "status": "Confirmed",
      "user_id": CurrentUser.uid,
      "address": user.address,
      "discount": discount,
      "total": cart.totalCost,
      "paymentUrl": response.paymentId,
      "products": product,
      "create_at": DateTime.now().millisecondsSinceEpoch,
      "receivedDate": 0,
      "onTheWayDate": 0
    };
    Navigator.pop(context);
    Navigator.pop(context);

    Navigator.pushNamed(context, "/payment_success", arguments: orderdata1);
    await Firestoreservices().emptyCart();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Payment Done",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Consumer<UserProvider>(
            builder: (context, userData, child) =>
                Consumer<CartProvider>(builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Detail",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(userData.email),
                              Text(userData.address),
                              Text(userData.phone),
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/update_profile");
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Have a Coupon?"),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          controller: _couponConstoller,
                          decoration: InputDecoration(
                              labelText: "Coupon Code",
                              hintText: "Enter Coupon for extra discount",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey.shade200),
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            QuerySnapshot querySnapshot =
                                await Firestoreservices().verifyCoupon(
                                    code: _couponConstoller.text.toUpperCase());
                            if (querySnapshot.docs.isNotEmpty) {
                              QueryDocumentSnapshot data =
                                  querySnapshot.docs.first;
                              String code = data.get("code");
                              int percent = data.get("discount");
                              int min = data.get("min_amount");
                              if (min < value.totalCost) {
                                discountText =
                                    "A discount of $percent% has been applied";
                                DiscountCaluclator(percent, value.totalCost);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text("This price is not able to apply"),
                                  backgroundColor:
                                      const Color.fromARGB(255, 137, 126, 20),
                                ));
                              }
                            } else {
                              discountText = "No discount code found";
                            }
                            setState(() {});
                          },
                          child: Text("Apply")),
                    ],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  discountText == "" ? SizedBox() : Text(discountText),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Total Quantity of Product: ${value.totalQuantity}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Sub Total: $symbol ${value.totalCost}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    "Extra Discount : -$symbol $discount",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    "Total Payable : $symbol ${value.totalCost - discount}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            final userData = Provider.of<UserProvider>(context, listen: false);
            final value = Provider.of<CartProvider>(context, listen: false);
            if (userData.address == "" ||
                userData.email == "" ||
                userData.phone == "" ||
                userData.name == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please Fill your delivery detail")));
              return;
            }
            Razorpay razorpay = Razorpay();
            var options = {
              'key': dotenv.env["RAZORPAY_API_KEY"] ?? "",
              "currency": "INR",
              'amount': (value.totalCost - discount) * 100,
              'name': "RI Cart",
              'retry': {'enabled': true, 'max_count': 1},
              'send_sms_hash': true,
              'prefill': {
                'name': userData.name,
                'contact': userData.phone,
                'email': userData.email
              },
              'external': {
                'wallets': ['paytm']
              }
            };
            razorpay.on(
                Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
            razorpay.on(
                Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);

            razorpay.open(options);
          },
          child: const Text("Process to Pay"),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white),
        ),
      ),
    );
  }
}
