import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String Status;
  final int day;
  const Timeline(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.Status,
      required this.day});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        beforeLineStyle: LineStyle(
          color: widget.Status == "Cancelled"
              ? Colors.red
              : widget.isPast
                  ? Colors.green
                  : Colors.grey,
        ),
        indicatorStyle: IndicatorStyle(
            width: 30,
            color: widget.Status == "Cancelled"
                ? Colors.red
                : widget.isPast
                    ? Colors.green
                    : Colors.grey,
            iconStyle: IconStyle(
                iconData:
                    widget.Status == "Cancelled" ? Icons.close : Icons.done,
                color: Colors.white)),
        endChild: Container(
          margin: EdgeInsets.only(top: 37, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.Status,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(widget.day > 0
                  ? DateTime.fromMillisecondsSinceEpoch(widget.day)
                      .toString()
                      .formattedDate()
                  : "..."),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
