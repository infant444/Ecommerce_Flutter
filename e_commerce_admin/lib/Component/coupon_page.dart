import 'package:e_commerce_admin/container/additional_confirm.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/coupon.model.dart';
import 'package:flutter/material.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coupons"),
      ),
      body: StreamBuilder(
          stream: FirestoreServices().readCouponCode(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Coupon> coupons =
                  Coupon.fromJsonList(snapshot.data!.docs) as List<Coupon>;
              if (coupons.isEmpty) {
                return Center(
                  child: Text("No coupon found"),
                );
              }
              return ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("What you want to do"),
                                  content:
                                      Text("Delete action cannot be undone"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AdditionalConfirm(
                                                      text:
                                                          "Are you sure you want to delete this",
                                                      onYes: () {
                                                        Navigator.pop(context);
                                                        FirestoreServices()
                                                            .deleteCouponCode(
                                                                id: coupons[
                                                                        index]
                                                                    .id);
                                                      },
                                                      onNo: () {
                                                        Navigator.pop(context);
                                                      }));
                                        },
                                        child: Text("Delete Coupon")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, "/update_coupon",
                                              arguments: coupons[index]);
                                        },
                                        child: Text("Update Coupon")),
                                  ],
                                ));
                      },
                      leading: Container(
                        height: 70,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "${coupons[index].discount}%",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      title: Text(coupons[index].code),
                      subtitle: Text(coupons[index].desc),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/update_coupon",
                                arguments: coupons[index]);
                          },
                          icon: Icon(Icons.edit_outlined)),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/update_coupon");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
