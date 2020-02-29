import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:tryst_20_user/events/event_class.dart';

import 'category_events.dart';

class CategoryCard extends StatelessWidget {
  final EventCategory category;

  CategoryCard(this.category);

  // Future onButtonPress() async {
  //   print("Subbing to Club ${_club.clubName}");
  //   color = Colors.grey;
  //   onPress = () {};
  //   setState(() {});
  //   final response = await http.post("$url/api/body/${_club.id}/subscribe",
  //       headers: {"authorization": "Bearer $token"});
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     _club.isSubbed = !_club.isSubbed;
  //     if (_club.isSubbed) {
  //       otherClubs.remove(_club);
  //       subbedClubs.add(_club);
  //     } else {
  //       subbedClubs.remove(_club);
  //       otherClubs.add(_club);
  //     }
  //   }
  //   color = Colors.white;
  //   refresh();
  // }

  // Future onSub() async {
  //   print("Subbing to club");
  //   color = Colors.grey;
  //   setState(() {});
  //   final response = await http.
  // }

  @override
  Widget build(BuildContext context) {
    print("Club Card received:::");
    print(category);
    // Icon _icon;
    // String _toolTip;
    // if (_club.isSubbed) {
    //   _icon = Icon(Icons.remove_circle);
    //   _toolTip = 'Unsubscribe';
    // } else {
    //   _icon = Icon(Icons.add_circle_outline);
    //   _toolTip = 'Subscribe';
    // }
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CategoryEvents(category)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(15)
        ),
        padding: EdgeInsets.symmetric(vertical: 30),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: AutoSizeText(
                    category.id,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            // IconButton(
            //   onPressed: onPress,
            //   icon: _icon,
            //   color: color,
            //   tooltip: _toolTip,
            //   padding: EdgeInsets.all(0),
            // ),
          ],
        ),
      ),
    );
  }
}
