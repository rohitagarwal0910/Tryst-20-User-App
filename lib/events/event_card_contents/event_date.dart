import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDate extends StatelessWidget {
  final DateTime _datetime;

  EventDate(this._datetime);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: <Widget>[
          Text('DATE', style: TextStyle(color: Colors.white70, fontSize: 9)),
          Text(
            DateFormat('d MMM').format(_datetime),
            style: TextStyle(color: Colors.white, fontSize: 13),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
