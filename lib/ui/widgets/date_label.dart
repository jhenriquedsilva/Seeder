import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateLabel extends StatelessWidget {
  const DateLabel({Key? key, required this.date}) : super(key: key);

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return date == null
        ? Icon(
      Icons.calendar_month,
      color: Theme.of(context).primaryColor,
    )
        : Text(
      DateFormat('dd/MM/yyyy')
          .format(date!),
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 22),
    );
  }
}
