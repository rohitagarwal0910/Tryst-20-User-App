import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tryst_20_user/globals.dart';
import '../event_class.dart';

class StarButton extends StatefulWidget {
  final Event _event;
  final Function _reorderList;

  StarButton(this._event, this._reorderList){
    _event.isStarred=(currentUser.starredevents.contains(_event.id))?true:false;
  }

  @override
  State<StatefulWidget> createState() {
    return StarButtonState();
  }
}

class StarButtonState extends State<StarButton> {
  Icon _icon;
  String _toolTip;
  Event _event;
  Function _reorderList;
  Function onpress;

  @override
  void initState() {
    super.initState();
    _reorderList = widget._reorderList;
    _event = widget._event;
    onpress = () {
      onStarPress();
    };
    if (_event.isStarred) {
      _icon = Icon(
        Icons.star,
        color: Colors.amberAccent,
      );
      _toolTip = 'Unstar';
    } else {
      _icon = Icon(
        Icons.star_border,
        color: Colors.white,
      );
      _toolTip = 'Star';
    }
  }

  Future<Null> starEvent(String eventid) async {
    print("Starring Event");
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    String _url = '$url/api/user/starEvents';

    HttpClientRequest request = await client.postUrl(Uri.parse(_url));
    Map map = {"event_id": _event.id};

    request.headers.set('content-type', 'application/json');
    request.headers.set("x-auth-token", "$token");
    request.add(utf8.encode(json.encode(map)));

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(reply);
      if (parsedJson["error"] == false) {
        _event.isStarred = !_event.isStarred;
        if (_event.isStarred) {
          _icon = Icon(
            Icons.star,
            color: Colors.amberAccent,
          );
          _toolTip = 'Unstar';
          starredEvents.add(eventsList.firstWhere((t) => t.id == _event.id));
          currentUser.starredevents.add(_event.id);
        } else {
          _icon = Icon(
            Icons.star_border,
            color: Colors.white,
          );
          _toolTip = 'Star';
          starredEvents.remove(starredEvents.firstWhere((t) => t.id == _event.id));
          currentUser.starredevents.remove(_event.id);
        }
        // refreshLists(_event);
        onpress = () {
          onStarPress();
        };
        setState(() {});
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
                (_event.isStarred) ? "Event Starred" : "Event Unstarred")));
        
      }
    } else {
      if (_event.isStarred) {
          _icon = Icon(
            Icons.star,
            color: Colors.amberAccent,
          );
          _toolTip = 'Unstar';
        } else {
          _icon = Icon(
            Icons.star_border,
            color: Colors.white,
          );
          _toolTip = 'Star';
        }
        onpress = () {
          onStarPress();
        };
        setState(() {});
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
                (_event.isStarred) ? "Could not unstar event" : "Could not star event")));
      throw Exception("Failed to star event");
    }
  }

  void onStarPress() {
    setState(() {
      _icon = Icon(
        Icons.star,
        color: Colors.white54,
      );
      onpress = () {};
    });
    starEvent(_event.eventid);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpress,
      icon: _icon,
      tooltip: _toolTip,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
