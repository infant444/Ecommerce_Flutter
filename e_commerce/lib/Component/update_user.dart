import 'dart:io';

import 'package:e_commerce/Controllers/Cloudinary_services.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/Provider/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _profileController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _addressController.text = user.address;
    _phoneController.text = user.phone;
    _profileController.text = user.profile;
  }

  Future<void> PickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? res = await uploadToCloudinary(image);
      setState(() {
        if (res != null) {
          _profileController.text = res;
          print("Set profile url $res : ${_profileController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image uploaded successfully")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: image == null
                          ? _profileController.text.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.deepPurple.shade50,
                                      child: Image.network(
                                        _profileController.text,
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : SizedBox()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.deepPurple.shade50,
                                  child: Image.file(
                                    File(image!.path),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value!.isEmpty ? "Name cannot be empty" : null,
                    decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Name",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    validator: (value) =>
                        value!.isEmpty ? "Email cannot be empty" : null,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Email",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController,
                    validator: (value) =>
                        value!.isEmpty ? "Address cannot be empty" : null,
                    decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Address",
                        border: OutlineInputBorder()),
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Phone cannot be empty" : null,
                    decoration: InputDecoration(
                        labelText: "Phone",
                        hintText: "Phone",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // ElevatedButton(
                  //     onPressed: () {
                  //       PickImage();
                  //     },
                  //     child: const Text("Pick Profile")),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _profileController,
                    validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                    decoration: InputDecoration(
                        hintText: "Profile Link",
                        label: const Text("Profile Link"),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              PickImage();
                            },
                            icon: Icon(
                              Icons.cloud_upload_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .7,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var data = {
                              "name": _nameController.text,
                              "address": _addressController.text,
                              "email": _emailController.text,
                              "phone": _phoneController.text,
                              "profile": _profileController.text,
                            };
                            await Firestoreservices()
                                .updateUserData(extraData: data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Profile Updated")));
                          }
                        },
                        child: Text("Update Profile")),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
