import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:tryst_20_user/globals.dart';
import './updates_class.dart';
import './update.dart';

// Future<List<Update>> getUpdates(String eventid) async {
//   HttpClient client = new HttpClient();
//   client.badCertificateCallback =
//       ((X509Certificate cert, String host, int port) => true);

//   String _url = '$url/api/event/view/$eventid';

//   HttpClientRequest request = await client.getUrl(Uri.parse(_url));

//   request.headers.set('content-type', 'application/json');
//   request.headers.set("x-auth-token", "$token");

//   HttpClientResponse response = await request.close();

//   String reply = await response.transform(utf8.decoder).join();
//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     var parsedJson = json.decode(reply);
//     List<Update> updateList = List<Update>();
//     for (int i = 0; i < parsedJson["data"]["updates"].length; i++) {
//       Update update = Update.fromJson(parsedJson["data"]["updates"][i]);
//       updateList.add(update);
//     }
//     return updateList;
//   } else {
//     throw Exception("Failed");
//   }
// }

class EventUpdatesList extends StatefulWidget {
  List<Update> updates;

  EventUpdatesList(this.updates);

  @override
  State<StatefulWidget> createState() {
    return EventUpdatesListState();
  }
}

class EventUpdatesListState extends State<EventUpdatesList> {
  List<Update> upd;

  @override
  void initState() {
    super.initState();
    upd = widget.updates;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'UPDATES',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 4),
          ),
          Container(
            height: 3,
            width: 60,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Colors.blue,
          ),
          // FutureBuilder(
          //   future: _updates,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          // List<Update> upd = snapshot.data;
          // if (upd.isEmpty)
          //   return Container(
          //     margin: EdgeInsets.all(25),
          //     child: Center(
          //       child: Text(
          //         "No Updates",
          //         style: TextStyle(
          //           color: Colors.white70,
          //         ),
          //       ),
          //     ),
          //   );
          // else
          // return
          Column(
            children: upd
                .map((element) => EventUpdate(element, ValueKey(element.id)))
                .toList(),
          )
          // } else if (snapshot.hasError) {
          //   return Center(
          //     child: Text(
          //       "Some Error Occured",
          //       style: TextStyle(color: Colors.white70),
          //     ),
          //   );
          // }

          // return Container(
          //   margin: EdgeInsets.all(20),
          //   child: Center(
          //     child: CircularProgressIndicator(
          //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          //     ),
          //   ),
          // );
          // },
          // ),
        ],
      ),
    );
  }
}
