import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/coupon.model.dart';
import 'package:flutter/material.dart';

class ModifyCoupon extends StatefulWidget {
  const ModifyCoupon({super.key});

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  late String couponId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController minAmountController = TextEditingController();
  setDate(Coupon data) {
    couponId = data.id;
    codeController.text = data.code;
    descController.text = data.desc;
    discountController.text = data.discount.toString();
    minAmountController.text = data.min_amount.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    if (argument != null && argument is Coupon) {
      setDate(argument);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(couponId.isNotEmpty ? "Update Coupon" : "Add Coupon"),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: codeController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
                      decoration: InputDecoration(
                          hintText: "Code",
                          label: Text("Code"),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
                      decoration: InputDecoration(
                          hintText: "description",
                          label: Text("description"),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: discountController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
                      decoration: InputDecoration(
                          hintText: "Discount",
                          label: Text("Discount"),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: minAmountController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
                      decoration: InputDecoration(
                          hintText: "Minimum Amount",
                          label: Text("Minimum Amount"),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Map<String, dynamic> data = {
                                "code": codeController.text.toUpperCase(),
                                "discount": int.parse(discountController.text),
                                "desc": descController.text,
                                "min_amount":
                                    int.parse(minAmountController.text),
                              };
                              if (couponId.isNotEmpty) {
                                FirestoreServices()
                                    .updateCouponCode(id: couponId, data: data);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Coupon Code updated successfully...")));
                              } else {
                                FirestoreServices()
                                    .createCouponCode(data: data);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Coupon Code add successfully...")));
                              }
                            }
                          },
                          child: Text(couponId.isNotEmpty
                              ? "Update Coupon"
                              : "Add Coupon")),
                    )
                  ])))),
    );
  }
}
