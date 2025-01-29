// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:e_commerce_admin/controllers/auth_server.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text("Get started with your account"),
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
              // password
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

              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text("Forgot Password"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Enter the email"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text("Email"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            if (_emailController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Email cannot be empty",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            AuthService()
                                                .resetPassword(
                                                    _emailController.text)
                                                .then((value) {
                                              if (value == "mail send") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Password reset link send to your email"),
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      value,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: Text("Submit")),
                                    ],
                                  );
                                })
                          },
                      child: Text(
                        "Forgot Password",
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //login
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .7,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AuthService()
                            .loginAccountWithEmail(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          if (value == "Login Successfully") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Login Successfully")));
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
                      "Login",
                      style: TextStyle(fontSize: 16),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have and account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text("Sign Up")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
