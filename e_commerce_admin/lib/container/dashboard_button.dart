// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';

class DashboardButton extends StatefulWidget {
  final String name;
  VoidCallback ontap;
  DashboardButton({super.key, required this.ontap, required this.name});

  @override
  State<DashboardButton> createState() => _DashboardButtonState();
}

class _DashboardButtonState extends State<DashboardButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * .42,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            "${widget.name} ",
            style: TextStyle(color: Colors.white70, fontSize: 20),
          ),
        ),
      ),
      onTap: widget.ontap,
    );
  }
}
