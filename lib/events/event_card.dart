import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

// import 'package:tryst_20_user/events/event_info/star_button.dart';

import './event_class.dart';
import './event_info/event_info_screen.dart';
import './event_card_contents/event_time.dart';
import './event_card_contents/event_venue.dart';

class EventCard extends StatelessWidget {
  final EventDay _event;
  final Function _onStarPress;
  final bool showDate;

  EventCard(this._event, this._onStarPress, Key key, {this.showDate = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Icon _icon;
    // String _toolTip;
    // if (_event.isStarred) {
    //   _icon = Icon(Icons.star, color: Colors.amberAccent);
    //   _toolTip = 'Unstar';
    // } else {
    //   _icon = Icon(
    //     Icons.star_border,
    //     color: Colors.white,
    //   );
    //   _toolTip = 'Star';
    // }

    DateTime d = DateTime.parse(_event.schedule.day);
    print("${_event.event.name} - ${_event.schedule.start_time}");
      DateTime start = DateTime(d.year, d.month, d.day, _event.schedule.start_time.hour, _event.schedule.start_time.minute);
      DateTime end = DateTime(d.year, d.month, d.day, _event.schedule.end_time.hour, _event.schedule.end_time.minute);
    EventTime et = EventTime(start, end, showDate: showDate,);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventInfo(_event.event.id, _onStarPress)));
        // _onStarPress();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
        margin: EdgeInsets.symmetric(vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${_event.event.name}${(_event.schedule.type != "General") ? " - " + _event.schedule.type : ""}",
                          style: TextStyle(fontSize: 23, color: Colors.white),
                          minFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        AutoSizeText(
                          _event.event.category.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                //   IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.calendar_today),
                //   color: Colors.white,
                //   tooltip: 'Add to Calendar',
                // ),
                // IconButton(
                //   onPressed: () {
                //     _event.isStarred = !_event.isStarred;
                //     refreshLists(_event);
                //     _onStarPress(_event);
                //   },
                //   icon: _icon,
                //   tooltip: _toolTip,
                //   splashColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                // ),
                // StarButton(_event, _onStarPress)
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: EventVenue(_event.schedule.venue),
                ),
                Expanded(
                  child: et,
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
