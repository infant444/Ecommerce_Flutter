import 'dart:io';

import 'package:e_commerce_admin/controllers/cloudnary_services.dart';
import 'package:e_commerce_admin/controllers/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory(
      {super.key,
      required this.isUpdating,
      this.name,
      required this.categoryId,
      this.image,
      required this.priority});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("All will be Converted to lowercase"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                decoration: InputDecoration(
                    hintText: "Category Name",
                    label: const Text("Category Name"),
                    fillColor: Colors.blueGrey.shade100,
                    filled: true),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("This will be used in ordering categories"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: priorityController,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                decoration: InputDecoration(
                    hintText: "Priority",
                    label: const Text("Priority"),
                    fillColor: Colors.blueGrey.shade100,
                    filled: true),
              ),
              const SizedBox(
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
              ElevatedButton(
                  onPressed: () {
                    PickImage();
                  },
                  child: const Text("Pick Image")),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                decoration: InputDecoration(
                    hintText: "Image Link",
                    label: const Text("Image Link"),
                    fillColor: Colors.blueGrey.shade100,
                    filled: true),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.isUpdating) {
                  await FirestoreServices()
                      .updateCategories(id: widget.categoryId, data: {
                    "name": categoryController.text.toLowerCase(),
                    "img": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Category Updated...")));
                } else {
                  await FirestoreServices().createCategories(data: {
                    "name": categoryController.text.toLowerCase(),
                    "img": imageController.text,
                    "priority": int.parse(priorityController.text)
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Category Added...")));
                }
                Navigator.pop(context);
              }
            },
            child: Text(widget.isUpdating ? "Update" : "Add"))
      ],
    );
  }
}
