import 'package:flutter/material.dart';

class EventVenue extends StatelessWidget {
  final String _venue;
  final bool showAsRow;

  EventVenue(this._venue, {this.showAsRow = false});

  @override
  Widget build(BuildContext context) {
    if (!showAsRow)
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Text('AT', style: TextStyle(color: Colors.white70, fontSize: 9)),
            Text(
              _venue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('AT : ', style: TextStyle(color: Colors.white70, fontSize: 9)),
            Text(
              _venue,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
  }
}
