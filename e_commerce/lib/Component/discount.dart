import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/coupon.model.dart';
import 'package:flutter/material.dart';

class Discount extends StatefulWidget {
  const Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discount Coupons "),
      ),
      body: StreamBuilder(
          stream: Firestoreservices().readDiscount(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Coupon> discount =
                  Coupon.fromJsonList(snapshot.data!.docs) as List<Coupon>;
              if (discount.isEmpty) {
                return SizedBox();
              } else {
                return ListView.builder(
                  itemCount: discount.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.discount_outlined),
                      title: Text(discount[i].code),
                      subtitle: Text(discount[i].desc),
                    );
                  },
                );
              }
            }
            return SizedBox();
          }),
    );
  }
}
