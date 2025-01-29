import 'dart:io';

import 'package:e_commerce_admin/controllers/cloudnary_services.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:e_commerce_admin/model/promo_Banner.model.dart';
import 'package:e_commerce_admin/provider/admin.provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ModifyPromo extends StatefulWidget {
  const ModifyPromo({super.key});

  @override
  State<ModifyPromo> createState() => _ModifyPromoState();
}

class _ModifyPromoState extends State<ModifyPromo> {
  late String promoId = "";
  final formKey = GlobalKey<FormState>();

  TextEditingController imageController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  bool _isInitialized = false;
  bool _ispromo = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final argument = ModalRoute.of(context)?.settings.arguments;
        if (argument != null && argument is Map<String, dynamic>) {
          if (argument["detail"] is PromoBanner) {
            setData(argument["detail"] as PromoBanner);
          }
          _ispromo = argument["promo"] ?? true;
          _isInitialized = true;
          setState(() {});
        }
      }
    });
  }

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

  setData(PromoBanner data) {
    promoId = data.id;
    titleController.text = data.title;
    categoryController.text = data.category;
    imageController.text = data.image;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)!.settings.arguments;
    if (argument != null && argument is PromoBanner) {
      setData(argument);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(promoId.isNotEmpty
              ? "Update${_ispromo ? "Promos" : "Banner"}"
              : "Add ${_ispromo ? "Promos" : "Banner"}"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: titleController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
                      decoration: InputDecoration(
                          hintText: "Title",
                          label: Text("Title"),
                          fillColor: Colors.deepPurple.shade50,
                          filled: true),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: categoryController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                                    .text =
                                                                e["name"];
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Text(
                                                            e["name"],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                    ElevatedButton(
                        onPressed: PickImage, child: Text("Pick Image")),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: imageController,
                      validator: (v) =>
                          v!.isEmpty ? "This can't be empty" : null,
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
                                "title": titleController.text,
                                "image": imageController.text,
                                "category": categoryController.text,
                              };
                              if (promoId.isNotEmpty) {
                                FirestoreServices().updatePromo(
                                    id: promoId, data: data, isPromo: _ispromo);

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "${_ispromo ? "Promos" : "Banner"} updated successfully...")));
                              } else {
                                FirestoreServices()
                                    .createPromo(data: data, isPromo: _ispromo);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "${_ispromo ? "Promos" : "Banner"} add successfully...")));
                              }
                            }
                          },
                          child: Text(promoId.isNotEmpty
                              ? "Update ${_ispromo ? "Promos" : "Banner"}"
                              : "Add ${_ispromo ? "Promos" : "Banner"}")),
                    )
                  ]),
                ))));
  }
}
