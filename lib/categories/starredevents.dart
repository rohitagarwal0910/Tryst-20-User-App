import 'package:flutter/material.dart';
import 'package:tryst_20_user/globals.dart';

import 'category_events.dart';

class StarEventList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StarEventListState();
  }
}

class StarEventListState extends State<StarEventList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: starredEvents.map((e) => CategoryEventCard(e)).toList(),);
  }
}