import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:tryst_20_user/globals.dart';
import './events_page.dart';
import './event_class.dart';

Widget loadingIcon() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  );
}

Widget errorMessage() {
  return Center(
    child: Text(
      "Some Error Occured",
      style: TextStyle(color: Colors.white70),
    ),
  );
}

class EventsTab extends StatefulWidget {
  final TabController _controller;

  EventsTab(this._controller);

  @override
  State<StatefulWidget> createState() {
    return EventsTabState();
  }
}

class EventsTabState extends State<EventsTab> {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = widget._controller;
  }

  Future<List<List<EventDay>>> getEvents() async {
    if (eventsList.length>0) return sortEvents();
    print("Getting Events");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    String _url = '$url/api/event/view';

    HttpClientRequest request = await client.getUrl(Uri.parse(_url));

    request.headers.set('content-type', 'application/json');
    request.headers.set("x-auth-token", "$token");

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    print(reply);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Events received");
      var parsedJson = json.decode(reply);
      // todayEvents = List<List<Event>>.generate(3, (i) => []);
      // tomorrowEvents = List<List<Event>>.generate(3, (i) => []);
      // upcomingEvents = List<List<Event>>.generate(3, (i) => []);
      eventsList = List<Event>();
      // if (parsedJson["message"] != "Events Found") {
      //   return [todayEvents, tomorrowEvents, upcomingEvents];
      // }
      print(parsedJson["data"].length);
      for (int i = 0; i < parsedJson["data"].length; i++) {
        Event ev = Event.fromJson(parsedJson["data"][i]);
        eventsList.add(ev);
      }
      print("wvfebrfvbrefv");
      currentUser.starredevents.forEach((ev) {
        Event foundev = eventsList.firstWhere((tempev) {
          return tempev.id == ev;
        });
        foundev.isStarred = true;
        starredEvents.add(foundev);
      });
      return sortEvents();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData || eventsList.length > 0) {
          return TabBarView(
            controller: _controller,
            children: [
              EventsPage("PREFEST"),
              EventsPage("DAY 1"),
              EventsPage("DAY 2"),
              EventsPage("DAY 3"),
            ],
          );
        } else if (snapshot.hasError) {
          // print(snapshot.data);
          return TabBarView(
            controller: _controller,
            children: [
              errorMessage(),
              errorMessage(),
              errorMessage(),
              errorMessage(),
            ],
          );
        }
        return TabBarView(
          controller: _controller,
          children: [
            loadingIcon(),
            loadingIcon(),
            loadingIcon(),
            loadingIcon(),
          ],
        );
      },
    );
  }
}
