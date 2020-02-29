import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tryst_20_user/events/events_tab.dart';
import 'package:tryst_20_user/globals.dart';
import 'package:tryst_20_user/events/event_class.dart';

import 'category_card.dart';

Future<List<List<EventDay>>> getEvents() async {
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
    return sortEvents();
  } else {
    throw Exception('Failed to load events');
  }
}

// class ClubsScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ClubsScreenState();
//   }
// }

class CategoriesTab extends StatelessWidget {
  // refresh() {
  //   print("refreshing club list");
  //   // if (widget.l == 0)
  //   //   clubs = subbedClubs;
  //   // else if (widget.l == 1) clubs = otherClubs;
  //   // clubs.forEach((f) => print(f.clubName));
  //   subbedClubs.sort((a, b) {
  //     return a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase());
  //   });
  //   otherClubs.sort((a, b) {
  //     return a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase());
  //   });
  //   print("Subbed Clubs:");
  //   subbedClubs.forEach((f) => print(f.clubName));
  //   print("Other Clubs:");
  //   otherClubs.forEach((f) => print(f.clubName));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    print("ClubScreenState build called");
    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData || eventsList.length>0) {
            return ListView(
              key: PageStorageKey('clubsTab'),
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                categoriesList(),
              ],
            );
          } else {
            return loadingIcon();
          }
        });
  }

  List<CategoryCard> makeClubCardList() {
    List<CategoryCard> toReturn = List<CategoryCard>();
    for (int i = 0; i < allCategories.length; i++) {
      toReturn.add(new CategoryCard(allCategories[i]));
    }
    return toReturn;
  }

  Widget categoriesList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: makeClubCardList(),
            // clubs
            //     .map((element) => ClubCard(element, refresh))
            //     .toList(),
          ),
        ],
      ),
    );
  }
}
