import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tryst_20_user/globals.dart';

import './event_class.dart';
import './events_list.dart';

class EventsPage extends StatefulWidget {
  final String _title;

  EventsPage(this._title);

  @override
  State<StatefulWidget> createState() {
    return EventsPageState();
  }
}

class EventsPageState extends State<EventsPage> {
  List<EventDay> _events;
  String _title, headertext;
  Function reload;

  @override
  void initState() {
    super.initState();
    _title = widget._title;
    switch (_title) {
      case "PREFEST":
        _events = prefestEvents;
        break;
      case "DAY 1":
        _events = day1Events;
        headertext = "6 MARCH";
        break;
      case "DAY 2":
        _events = day2Events;
        headertext = "7 MARCH";
        break;
      case "DAY 3":
        _events = day3Events;
        headertext = "8 MARCH";
        break;
      default:
    }
  }

  void reorderList() {
    setState(
      () {
        switch (_title) {
          case "PREFEST":
            _events = prefestEvents;
            break;
          case "DAY 1":
            _events = day1Events;
            headertext = "6 MARCH";
            break;
          case "DAY 2":
            _events = day2Events;
            headertext = "7 MARCH";
            break;
          case "DAY 3":
            _events = day3Events;
            headertext = "8 MARCH";
            break;
          default:
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: PageStorageKey(_title),
      child: Column(
        children: <Widget>[
          (_title != "PREFEST") ? Container(
            padding: EdgeInsets.only(top: 30, bottom: 10),
            child: Center(
              child: AutoSizeText(
                headertext,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ) : 
          Container(
            height: 10,
          ),
          EventsList(
              _events,
              'STARRED EVENTS',
              // _title,
              // starEvent,
              reorderList,
              showDateOnCard: (_title=="PREFEST"),),
          // EventsList(
          //     _events[1],
          //     'FROM SUBSCRIBTIONS',
          //     // _title,
          //     // starEvent,
          //     reorderList),
          // EventsList(
          //     _events[2],
          //     'OTHER EVENTS',
          //     // _title,
          //     // starEvent,
          //     reorderList),
          Container(
            height: 5,
          ),
        ],
        // SingleChildScrollView(
        //   key: PageStorageKey(_title),
        //   physics: AlwaysScrollableScrollPhysics(),
        //   child: Column(
        //     children: <Widget>[
        //       Text('STARRED EVENTS'),
        //       EventsList(_events[0], 'STARRED', starEvent),
        //       Text('FROM SUBSCRIBED CLUBS'),
        //       EventsList(_events[1], 'SUBBED', starEvent),
        //       Text('OTHER EVENTS'),
        //       EventsList(_events[2], 'OTHER', starEvent),
        //     ],
        //   ),
      ),
    );
  }
}
