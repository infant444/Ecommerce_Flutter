import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/coupon.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DiscountContainer extends StatefulWidget {
  const DiscountContainer({super.key});

  @override
  State<DiscountContainer> createState() => _DiscountContainerState();
}

class _DiscountContainerState extends State<DiscountContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestoreservices().readDiscount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Coupon> coupon =
                Coupon.fromJsonList(snapshot.data!.docs) as List<Coupon>;
            if (coupon.isEmpty) {
              return SizedBox();
            } else {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/discount"),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                      color: AdaptiveTheme.of(context).mode ==
                              AdaptiveThemeMode.dark
                          ? Colors.blueGrey.shade100
                          : Colors.lightBlue.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Use Coupon : ${coupon[0].code}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey),
                      ),
                      Text(coupon[0].desc,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.blueGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)
                    ],
                  ),
                ),
              );
            }
          } else {
            return SizedBox();
          }
        });
  }
}
