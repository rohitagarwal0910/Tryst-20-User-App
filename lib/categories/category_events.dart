import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:tryst_20_user/categories/category_card.dart';
import 'package:tryst_20_user/events/event_class.dart';
import 'package:tryst_20_user/events/event_info/event_info_screen.dart';
import 'package:tryst_20_user/globals.dart';

class CategoryEvents extends StatelessWidget {
  final EventCategory category;

  CategoryEvents(this.category);

  @override
  Widget build(BuildContext context) {
    List<Event> categoryeventslists = [];
    eventsList.forEach((e) {
      if (e.category == this.category) categoryeventslists.add(e);
    });
    categoryeventslists.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Colors.indigo,
        backgroundColorEnd: Colors.cyan,
        title: Text(category.id),
        centerTitle: true,
        // actions: <Widget>[ProfileIcon()],
      ),
      body: ListView(
        children: categoryeventslists.map((e) => CategoryEventCard(e)).toList(),
      ),
    );
  }
}

class CategoryEventCard extends StatelessWidget {
  final Event _event;

  CategoryEventCard(this._event);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventInfo(_event.id, () {})));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo, width: 3),
            image: (_event.photos.length > 0)
                ? DecorationImage(
                    image: NetworkImage(_event.photos[0][0]),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken))
                : null,
            color: Colors.indigo[700],
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(vertical: 30),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: <Widget>[
            AutoSizeText(
              _event.name,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                  shadows: <Shadow>[
                    (_event.photos.length > 0)
                        ? Shadow(
                            blurRadius: 10.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )
                        : null,
                  ]),
              textAlign: TextAlign.center,
            ),
            Container(
              height: 5,
            ),
            (_event.subheading != null && _event.subheading.isNotEmpty)
                ? AutoSizeText(
                    _event.subheading,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        shadows: <Shadow>[
                          (_event.photos.length > 0)
                              ? Shadow(
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )
                              : null,
                        ]),
                    maxLines: 1,
                  )
                : Container(
                    height: 0,
                  ),
            (_event.subheading != null && _event.subheading.isNotEmpty)
                ? Container(
                    height: 5,
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
