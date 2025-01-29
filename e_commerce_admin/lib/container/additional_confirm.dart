import 'package:flutter/material.dart';

class AdditionalConfirm extends StatefulWidget {
  final String text;
  final VoidCallback onYes, onNo;
  const AdditionalConfirm({
    super.key,
    required this.text,
    required this.onYes,
    required this.onNo,
  });

  @override
  State<AdditionalConfirm> createState() => _AdditionalConfirmState();
}

class _AdditionalConfirmState extends State<AdditionalConfirm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(widget.text),
      actions: [
        TextButton(onPressed: widget.onNo, child: Text("No")),
        TextButton(onPressed: widget.onYes, child: Text("Yse")),
      ],
    );
  }
}
