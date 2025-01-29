import 'package:flutter/material.dart';

class DashBoardText extends StatefulWidget {
  final String keyWord, value;
  const DashBoardText({super.key, required this.keyWord, required this.value});

  @override
  State<DashBoardText> createState() => _DashBoardTextState();
}

class _DashBoardTextState extends State<DashBoardText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          " ${widget.keyWord} :",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          " ${widget.value} ",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
