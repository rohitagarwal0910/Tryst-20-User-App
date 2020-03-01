import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './updates_class.dart';

class EventUpdate extends StatelessWidget {
  final Update _update;

  EventUpdate(this._update, Key key) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 7),
        padding: EdgeInsets.only(top: 15, right: 25, left: 25, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0x22AAAAAA)
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_update.message, style: TextStyle(color: Colors.white),),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     Text(DateFormat('d MMM').format(_update.dateTime),  style: TextStyle(fontSize: 10, color: Colors.white54),),
            //     Text(' • ', style: TextStyle(color: Colors.white54),),
            //     Text(DateFormat('h:mm a').format(_update.dateTime), style: TextStyle(fontSize: 10, color: Colors.white54),)
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}