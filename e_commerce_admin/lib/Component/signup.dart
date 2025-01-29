// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:e_commerce_admin/controllers/auth_server.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conformPasswordController = TextEditingController();
  bool _conformPasswordVisibleController = true;
  bool _passwordVisibleController = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text("Create a new account and Get started"),
                    SizedBox(
                      height: 10,
                    ),

                    //email
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Email cannot be empty" : null,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //Password
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) => value!.length < 8
                      ? "Password can be atleast 8 character"
                      : null,
                  controller: _passwordController,
                  obscureText: _passwordVisibleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisibleController =
                                  !_passwordVisibleController;
                            });
                          },
                          icon: Icon(_passwordVisibleController
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //confirm Password
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: TextFormField(
                  validator: (value) =>
                      (value!.length < 8 && value != _passwordController.text)
                          ? "Password not match"
                          : null,
                  controller: _conformPasswordController,
                  obscureText: _conformPasswordVisibleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Conform Password"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _conformPasswordVisibleController =
                                  !_conformPasswordVisibleController;
                            });
                          },
                          icon: Icon(_conformPasswordVisibleController
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
              ),

              //sign Up button
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .7,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .createAccountWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          if (value == "Account Created") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Account Created Successfully")));
                            Navigator.restorablePushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ));
                          }
                        });
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have and account"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
