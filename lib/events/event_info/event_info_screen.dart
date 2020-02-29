import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:convert';
import 'dart:async';
// import 'package:http/http.dart' as http;
import 'package:tryst_20_user/globals.dart';

import '../event_class.dart';
import './event_info_card.dart';
import './event_about.dart';
// import './event_updates_list.dart';

Future<Event> getEvent(String eventid) async {
  HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    String _url = '$url/api/event/view/$eventid';

    HttpClientRequest request = await client.getUrl(Uri.parse(_url));

    request.headers.set('content-type', 'application/json');
    request.headers.set("x-auth-token", "$token");

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
  if (response.statusCode == 200) {
    var parsedJson = json.decode(reply);
    Event event = Event.fromJson(parsedJson["data"]);
    return event;
  } else {
    throw Exception("Failed to load Event");
  }
}

class EventInfo extends StatefulWidget {
  final String id;
  final Function _reorderLists;
  final bool showButton;

  EventInfo(this.id, this._reorderLists, {this.showButton = true});

  @override
  State<StatefulWidget> createState() {
    return EventInfoState();
  }
}

class EventInfoState extends State<EventInfo> {
  String id;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Colors.indigo,
        backgroundColorEnd: Colors.cyan,
        title: Text('Event'),
        centerTitle: true,
        // actions: <Widget>[ProfileIcon()],
      ),
      body: FutureBuilder(
        future: getEvent(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                EventInfoCard(snapshot.data, widget._reorderLists, showButton: widget.showButton,),
                EventAbout(snapshot.data),
                // EventUpdatesList(snapshot.data.eventid)
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Some Error Occured"),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      ),
    );
  }
}
