import 'package:e_commerce_admin/controllers/timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderStatus extends StatefulWidget {
  final String status;
  final int create_at;
  final int receivedDate;
  final int onTheWayDate;
  const OrderStatus(
      {super.key,
      required this.status,
      required this.create_at,
      required this.receivedDate,
      required this.onTheWayDate});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    final isReceived = widget.status == 'ON_THE_WAY' ||
        widget.status == 'Confirmed' ||
        widget.status == 'DELIVERED';
    final isOnTheWay =
        widget.status == 'ON_THE_WAY' || widget.status == 'DELIVERED';
    final isDelivered = widget.status == 'DELIVERED';
    return widget.status == "CANCELLED"
        ? ListView(
            children: [
              Timeline(
                  isFirst: true,
                  isLast: false,
                  isPast: true,
                  Status: 'Processing',
                  day: widget.create_at),
              Timeline(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  Status: 'Order Received',
                  day: widget.create_at),
              Timeline(
                  isFirst: false,
                  isLast: true,
                  isPast: true,
                  Status: 'Cancelled',
                  day: widget.onTheWayDate),
            ],
          )
        : ListView(
            children: [
              Timeline(
                  isFirst: true,
                  isLast: false,
                  isPast: isReceived,
                  Status: 'Processing',
                  day: widget.create_at),
              Timeline(
                  isFirst: false,
                  isLast: false,
                  isPast: isReceived,
                  Status: 'Order Received',
                  day: widget.create_at),
              Timeline(
                  isFirst: false,
                  isLast: false,
                  isPast: isOnTheWay,
                  Status: 'On the Way',
                  day: widget.onTheWayDate),
              Timeline(
                  isFirst: false,
                  isLast: true,
                  isPast: isDelivered,
                  Status: 'Delivery',
                  day: widget.receivedDate),
            ],
          );
  }
}
