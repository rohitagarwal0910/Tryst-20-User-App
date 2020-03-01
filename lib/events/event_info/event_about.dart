import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tryst_20_user/error_alert.dart';
import 'package:tryst_20_user/events/event_card_contents/event_date.dart';
import 'package:tryst_20_user/events/event_card_contents/event_time.dart';
import 'package:tryst_20_user/events/event_card_contents/event_venue.dart';
import 'package:tryst_20_user/events/event_info/event_updates_list.dart';
import 'package:tryst_20_user/loading.dart';
import '../../globals.dart';
import '../event_class.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:flutter_advanced_networkimage/provider.dart';
// import 'package:flutter_advanced_networkimage/transition.dart';
// import 'package:flutter_advanced_networkimage/zoomable.dart';
// import 'package:photo_view/photo_view.dart';

class EventAbout extends StatelessWidget {
  final Event _event;
  final List updates;

  EventAbout(this._event, this.updates);

  @override
  Widget build(BuildContext context) {
    String about = _event.description;
    // if (_event.category_name.isNotEmpty)
    if (_event.prizes != null &&
        _event.prizes.isNotEmpty &&
        _event.prizes != '0') {
      about = "$about\n"
          "Prizes worth Rs. ${_event.prizes}";
    }

    if (_event.category_name != null &&
        _event.category_name.isNotEmpty &&
        !_event.category_name.startsWith('Tryst') &&
        !_event.category_name.startsWith('tryst')) {
      about = "$about\n\n"
          "Organised by: ${_event.category_name}";
    }
    List<Widget> toReturn = [];

    toReturn.add(Text(
      'SCHEDULE',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 15,
          letterSpacing: 4),
    ));
    toReturn.add(Container(
      height: 3,
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue,
    ));
    toReturn.add(Container(
      height: 10,
    ));

    DateTime d = DateTime.parse(_event.dtv_details[0].day);
    DateTime start = DateTime(
        d.year,
        d.month,
        d.day,
        _event.dtv_details[0].start_time.hour,
        _event.dtv_details[0].start_time.minute);
    DateTime end = DateTime(
        d.year,
        d.month,
        d.day,
        _event.dtv_details[0].end_time.hour,
        _event.dtv_details[0].end_time.minute);
    EventTime et = EventTime(
      start,
      end,
    );

    if (_event.dtv_details[0].type != 'General') {
      toReturn.add(
        Center(
          child: Text(
            _event.dtv_details[0].type,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      toReturn.add(Container(
        height: 10,
      ));
    }

    toReturn.add(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            child: EventVenue(
          _event.dtv_details[0].venue,
        )),
        Container(child: EventDate(d)),
        Container(
            // padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 20),
            child: et),
      ],
    ));
    // toReturn.add(
    //   Container(
    //       child: EventVenue(
    //     _event.dtv_details[0].venue,
    //     showAsRow: true,
    //   )),
    // );

    for (int i = 1; i < _event.dtv_details.length; i++) {
      toReturn.add(Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 0.5,
        color: Colors.white70,
      ));
      DateTime d = DateTime.parse(_event.dtv_details[i].day);
      DateTime start = DateTime(
          d.year,
          d.month,
          d.day,
          _event.dtv_details[i].start_time.hour,
          _event.dtv_details[i].start_time.minute);
      DateTime end = DateTime(
          d.year,
          d.month,
          d.day,
          _event.dtv_details[i].end_time.hour,
          _event.dtv_details[i].end_time.minute);
      EventTime et = EventTime(
        start,
        end,
      );

      if (_event.dtv_details[i].type != 'General') {
        toReturn.add(
          Center(
            child: Text(
              _event.dtv_details[i].type,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        toReturn.add(Container(
          height: 10,
        ));
      }

      toReturn.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              child: EventVenue(
            _event.dtv_details[i].venue,
          )),
          Container(child: EventDate(d)),
          Container(
              // padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 20),
              child: et),
        ],
      ));
      // toReturn.add(
      //   Container(
      //       child: EventVenue(
      //     _event.dtv_details[0].venue,
      //     showAsRow: true,
      //   )),
      // );
    }

    toReturn.add(Container(
      height: 25,
    ));

    toReturn.add((updates.length>0)?EventUpdatesList(updates):Container());


    toReturn.add(Text(
      'ABOUT THE EVENT',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 15,
          letterSpacing: 4),
    ));
    toReturn.add(Container(
      height: 3,
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue,
    ));
    toReturn.add(
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: SelectableText(
          about,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
    if (_event.probURL != null && _event.probURL.isNotEmpty) {
      toReturn.add(
        GestureDetector(
            onTap: () async {
              if (await canLaunch(_event.probURL)) {
                await launch(_event.probURL);
              } else {
                throw 'Could not launch url';
              }
            },
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: _event.probURL));
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Copied link to clipboard'),
                duration: Duration(seconds: 1),
              ));
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Problem Statement:\n",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: '${_event.probURL}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.underline),
              )
            ]))),
      );
      toReturn.add(Container(
        height: 10,
      ));
    }

    if (!_event.registration) {
      toReturn.add(
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: SelectableText(
            "No registration is required to attend.",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    } else {
      if (_event.reg_type == "team") {
        toReturn.add(
          SelectableText(
            "Register in a team of ${_event.reg_min_team_size}${(_event.reg_max_team_size != _event.reg_min_team_size) ? " to " + _event.reg_max_team_size.toString() : ""} to attend.",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        );
      }
      toReturn.add(
        SelectableText(
          "Registration Deadline: ${DateFormat("d MMM h:mm a").format(_event.reg_deadline)}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      );

      String link;
      if (_event.reg_mode == "website") {
        link =
            // "https://tryst-iitd.org/${(_event.category.id != "Guest Lectures") ? "event" : "guestLecture"}/${_event.id}";
            "https://tryst-iitd.org/register/${_event.id}";
      } else if (_event.reg_mode == "email") {
        link = _event.reg_email;
      } else {
        link = _event.reg_link;
      }
      // toReturn.add(GestureDetector(
      //     onTap: () async {
      //       if (await canLaunch(link)) {
      //         await launch(link);
      //       } else {
      //         throw 'Could not launch url';
      //       }
      //     },
      //     onLongPress: () {
      //       Clipboard.setData(ClipboardData(text: link));
      //       Scaffold.of(context).showSnackBar(SnackBar(
      //         content: Text('Copied link to clipboard'),
      //         duration: Duration(seconds: 1),
      //       ));
      //     },
      //     child: RichText(
      //         text: TextSpan(children: [
      //       TextSpan(
      //         text: "Register at:\n",
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontWeight: FontWeight.w300,
      //           fontSize: 15,
      //           letterSpacing: 0.5,
      //         ),
      //       ),
      //       TextSpan(
      //         text: link,
      //         style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.w300,
      //             fontSize: 15,
      //             letterSpacing: 0.5,
      //             decoration: TextDecoration.underline),
      //       )
      //     ]))));
      // toReturn.add(Container(
      //   height: 20,
      // ));
      toReturn.add(Container(
        height: 10,
      ));
      toReturn.add(Center(
        child: RaisedButton(
          child: Text("REGISTER"),
          onPressed: () async {
            if (await canLaunch(link)) {
              await launch(link);
            } else {
              throw 'Could not launch url';
            }
          },
        ),
      ));
      toReturn.add(Container(
        height: 20,
      ));
    }

    if (_event.category.id != "Guest Lectures") {
      // if (_event.photos.length != 0) {
      //   toReturn.add(Center(
      //       child: Container(
      //     margin: EdgeInsets.only(bottom: 30),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(15),
      //       child: Image.network(_event.photos[0][0]),
      //     ),
      //   )));
      // }
    } else {
      if (_event.photos.length != 0) {
        _event.photos.forEach((p) {
          toReturn.add(Center(
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(p[0])),
                Container(height: 10),
                SelectableText(
                  p[1],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(height: 5),
                SelectableText(
                  p[2],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(height: 30),
              ],
            ),
          ));
        });
      }
    }

    if (_event.rules.length > 0) {
      toReturn.add(
        Text(
          'RULES',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 4),
        ),
      );
      toReturn.add(
        Container(
          height: 3,
          width: 60,
          margin: EdgeInsets.symmetric(vertical: 10),
          color: Colors.blue,
        ),
      );
      for (int i = 0; i < _event.rules.length; i++) {
        toReturn.add(SelectableText(
          "${i + 1}. ${_event.rules[i]}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ));
      }
      toReturn.add(
        Container(
          height: 20,
        ),
      );
    }

    toReturn.add(
      Center(
        child: RaisedButton(
            child: Text("GET CERTIFICATE"),
            onPressed: () async {
              showLoading(context);
              HttpClient client = new HttpClient();
              var _downloadData = List<int>();
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;
              print(tempPath);
              var fileSave = new File(tempPath + '/cert.pdf');
              client.badCertificateCallback =
                  ((X509Certificate cert, String host, int port) => true);

              String _url = '$url/api/event/certificate';
              Map map = {"id": _event.id, "email": currentUser.email};
              // Map map = {"id": "EVENTmQVHQ", "email": "johndoe@gmail.com"};
              // try{
              HttpClientRequest request = await client.postUrl(Uri.parse(_url));
              request.headers.set("x-auth-token", "$token");
              request.headers.set('content-type', 'application/json');

              request.add(utf8.encode(json.encode(map)));
              HttpClientResponse _response = await request.close();
              print(_response.statusCode);
              if (_response.statusCode == 200) {
                _response.listen(
                  (d) => _downloadData.addAll(d),
                  onDone: () {
                    fileSave.writeAsBytes(_downloadData).then((File filesave) {
                      Navigator.pop(context);
                      OpenFile.open(tempPath + '/cert.pdf',
                          type: "application/pdf", uti: "com.adobe.pdf");
                    });
                  },
                );
                print("cert");
                // OpenFile.open('./cert.pdf', type: "application/pdf");
              } else {
                String response =
                    await _response.transform(utf8.decoder).join();
                Map<String, dynamic> parsedJson = json.decode(response);
                Navigator.pop(context);
                showErrorAlert(context, "Failed", parsedJson["message"]);
              }
            }),
      ),
    );

    toReturn.add(Container(
      height: 20,
    ));

    toReturn.add(
      Text(
        'CONTACT DETAILS',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 4),
      ),
    );
    toReturn.add(
      Container(
        height: 3,
        width: 60,
        margin: EdgeInsets.symmetric(vertical: 10),
        color: Colors.blue,
      ),
    );
    _event.poc_details.forEach((poc) {
      toReturn.add(SelectableText(
        "${poc.name}",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 17,
          letterSpacing: 0.5,
        ),
      ));
      toReturn.add(SelectableText(
        "${poc.designation}\n"
        "${poc.contact}\n"
        "${poc.email}",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ));
      toReturn.add(Container(
        height: 15,
      ));
    });

    // _event.photos.length

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: toReturn),
      ),
    );
  }
}
