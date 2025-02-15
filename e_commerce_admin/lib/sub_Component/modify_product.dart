import 'dart:io';

import 'package:e_commerce_admin/controllers/cloudnary_services.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/product.model.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({
    super.key,
  });

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  late int rating = 0;
  final ImagePicker picker = ImagePicker();
  late XFile? image;

  Future<void> PickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          imageController.text = res;
          print("Set image url $res : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image uploaded successfully")));
        }
      });
    }
  }

  setData(Product data) {
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    descriptionController.text = data.description;
    categoryController.text = data.category;
    imageController.text = data.image;
    rating = data.rating;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    if (argument != null && argument is Product) {
      setData(argument);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isNotEmpty ? "Update Product" : "Add Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "Product Name",
                      label: Text("Product Name"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "Description",
                      label: Text("Description"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: oldPriceController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "Original Price",
                      label: Text("Original Price"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newPriceController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "sell Price",
                      label: Text("sell Price"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "Quantity left",
                      label: Text("Quantity left"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: categoryController,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Category",
                      label: Text("Category"),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Select Category : "),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Consumer<AdminProvider>(
                                      builder: (context, value, child) =>
                                          SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: value.categories
                                                  .map(
                                                    (e) => TextButton(
                                                      onPressed: () {
                                                        categoryController
                                                            .text = e["name"];
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: Text(
                                                        e["name"],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ))
                                ],
                              ),
                            ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                image == null
                    ? imageController.text.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(20),
                            height: 100,
                            width: double.infinity,
                            color: Colors.deepPurple.shade50,
                            child: Image.network(
                              imageController.text,
                              fit: BoxFit.contain,
                            ))
                        : SizedBox()
                    : Container(
                        margin: EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        color: Colors.deepPurple.shade50,
                        child: Image.file(
                          File(image!.path),
                          fit: BoxFit.contain,
                        )),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: PickImage, child: Text("Pick Image")),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: imageController,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                      hintText: "Image Link",
                      label: Text("Image Link"),
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
                            "name": nameController.text,
                            "description": descriptionController.text,
                            "image": imageController.text,
                            "category": categoryController.text,
                            "old_price": int.parse(oldPriceController.text),
                            "new_price": int.parse(newPriceController.text),
                            "rating": rating,
                            "maxQuantity": int.parse(quantityController.text),
                          };
                          if (productId.isNotEmpty) {
                            FirestoreServices()
                                .updateProduct(id: productId, data: data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Product updated successfully...")));
                          } else {
                            FirestoreServices().createProduct(data: data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Product add successfully...")));
                          }
                        }
                      },
                      child: Text(productId.isNotEmpty
                          ? "Update Product"
                          : "Add Product")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
