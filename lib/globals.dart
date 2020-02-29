import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'events/event_class.dart';
// import 'clubs/club_class.dart';
import 'user_class.dart';

User currentUser;

List<Event> eventsList;

List<EventDay> prefestEvents = [];
List<EventDay> day1Events = [];
List<EventDay> day2Events = [];
List<EventDay> day3Events = [];

// List<List<Event>> todayEvents = List<List<Event>>.generate(3, (i) => []);
// List<List<Event>> tomorrowEvents = List<List<Event>>.generate(3, (i) => []);
// List<List<Event>> upcomingEvents = List<List<Event>>.generate(3, (i) => []);

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// List<Club> subbedClubs = List<Club>();
// List<Club> otherClubs = List<Club>();
// List<Club> allClubs = List<Club>();

Future<List<List<EventDay>>> sortEvents() async {
  prefestEvents.clear();
  day1Events.clear();
  day2Events.clear();
  day3Events.clear();
  // todayEvents = List<List<Event>>.generate(3, (i) => []);
  // tomorrowEvents = List<List<Event>>.generate(3, (i) => []);
  // upcomingEvents = List<List<Event>>.generate(3, (i) => []);
  eventsList.forEach((e) {
    e.dtv_details.forEach((d) {
      DateTime date = DateTime.parse(d.day);
      String ds = DateFormat("YYYYMMDD").format(date);
      if (date.isBefore(DateTime(2020, 3, 6))) {
        prefestEvents.add(EventDay(e, d));
      }
      if (ds == DateFormat("YYYYMMDD").format(DateTime(2020, 3, 6))) {
        day1Events.add(EventDay(e, d));
      }
      if ( ds == DateFormat("YYYYMMDD").format(DateTime(2020, 3, 7))) {
        day2Events.add(EventDay(e, d));
      }
      if (ds == DateFormat("YYYYMMDD").format(DateTime(2020, 3, 8))) {
        day3Events.add(EventDay(e, d));
      }
    });
  });
  // Event ev = eventsList[i];
  // bool isToday = ((DateTime.now().isAfter(ev.startsAt) &&
  //         DateTime.now().isBefore(ev.endsAt)) ||
  //     (DateTime.now().difference(ev.startsAt).inDays == 0 &&
  //         DateTime.now().day == ev.startsAt.day) ||
  //     (DateTime.now().difference(ev.endsAt).inDays == 0 &&
  //         DateTime.now().day == ev.endsAt.day));
  // bool isTommorow = ((DateTime.now()
  //             .add(Duration(days: 1))
  //             .isAfter(ev.startsAt) &&
  //         DateTime.now().add(Duration(days: 1)).isBefore(ev.endsAt)) ||
  //     (DateTime.now().add(Duration(days: 1)).difference(ev.startsAt).inDays ==
  //             0 &&
  //         DateTime.now().add(Duration(days: 1)).day == ev.startsAt.day) ||
  //     (DateTime.now().add(Duration(days: 1)).difference(ev.endsAt).inDays ==
  //             0 &&
  //         DateTime.now().add(Duration(days: 1)).day == ev.endsAt.day));
  // bool isUpcoming =
  //     (DateTime.now().add(Duration(days: 2)).isBefore(ev.endsAt) || (DateTime.now().add(Duration(days: 2)).difference(ev.endsAt).inDays ==
  //             0 &&
  //         DateTime.now().add(Duration(days: 2)).day == ev.endsAt.day));
  // if (isToday) {
  //   if (ev.isStarred)
  //     todayEvents[0].add(ev);
  //   else if (ev.isBodySub)
  //     todayEvents[1].add(ev);
  //   else
  //     todayEvents[2].add(ev);
  // }
  // if (isTommorow) {
  //   if (ev.isStarred)
  //     tomorrowEvents[0].add(ev);
  //   else if (ev.isBodySub)
  //     tomorrowEvents[1].add(ev);
  //   else
  //     tomorrowEvents[2].add(ev);
  // }
  // if (isUpcoming) {
  //   if (ev.isStarred)
  //     upcomingEvents[0].add(ev);
  //   else if (ev.isBodySub)
  //     upcomingEvents[1].add(ev);
  //   else
  //     upcomingEvents[2].add(ev);
  // }
  // for (int j = 0; j < 3; j++) {
  prefestEvents.sort((a, b) {
    return (DateTime.parse(a.schedule.day) != DateTime.parse(b.schedule.day))
        ? DateTime.parse(a.schedule.day)
            .compareTo(DateTime.parse(b.schedule.day))
        : (a.schedule.start_time != b.schedule.start_time)
            ? a.schedule.start_time.compareTo(b.schedule.start_time)
            : a.event.id.compareTo(b.event.id);
  });
  day1Events.sort((a, b) {
    return (a.schedule.start_time != b.schedule.start_time)
        ? a.schedule.start_time.compareTo(b.schedule.start_time)
        : a.event.id.compareTo(b.event.id);
  });
  day2Events.sort((a, b) {
    return (a.schedule.start_time != b.schedule.start_time)
        ? a.schedule.start_time.compareTo(b.schedule.start_time)
        : a.event.id.compareTo(b.event.id);
  });
  day3Events.sort((a, b) {
    return (a.schedule.start_time != b.schedule.start_time)
        ? a.schedule.start_time.compareTo(b.schedule.start_time)
        : a.event.id.compareTo(b.event.id);
  });
  // }
  return [prefestEvents, day1Events, day2Events, day3Events];
}

String url = "https://backend2020.tryst-iitd.org";
String title = "Tryst '20";
String token;

String headerKey = "x_auth_token";

// void refreshLists(Event event) {
//   bool isToday = (DateTime.now().difference(event.startsAt).inDays >= 0 &&
//       DateTime.now().difference(event.endsAt).inDays <= 0);
//   bool isTommorow = (DateTime.now()
//               .add(Duration(days: 1))
//               .difference(event.startsAt)
//               .inDays >=
//           0 &&
//       DateTime.now().add(Duration(days: 1)).difference(event.endsAt).inDays <=
//           0);
//   bool isUpcoming =
//       (DateTime.now().add(Duration(days: 1)).difference(event.endsAt).inDays <
//           0);
//   if (isToday) _refreshList(todayEvents, event);
//   if (isTommorow) _refreshList(tomorrowEvents, event);
//   if (isUpcoming) _refreshList(upcomingEvents, event);
// }

// void _refreshList(List<List<Event>> list, Event event) {
//   if (event.isStarred) {
//     list[0].add(event);
//     if (event.isBodySub) {
//       var tempev = list[1].firstWhere((eve) => eve.eventid == event.eventid);
//       list[1].remove(tempev);
//     } else {
//       var tempev = list[2].firstWhere((eve) => eve.eventid == event.eventid);
//       list[2].remove(tempev);
//     }
//   } else {
//     var tempev = list[0].firstWhere((eve) => eve.eventid == event.eventid);
//     list[0].remove(tempev);
//     if (event.isBodySub) {
//       list[1].add(event);
//     } else {
//       list[2].add(event);
//     }
//   }
//   for (int j = 0; j < 3; j++) {
//     list[j].sort((a, b) {
//       return a.startsAt.compareTo(b.startsAt);
//     });
//   }
// }

String about = "Following a dull period of the year, comes the glorious 3 days of Tryst '20. It is the arena where minded thoughts meet, where talent meets the triumph, the brainstorming meets the realism.\nIt is the perfect launchpad for the techies to showcase their intelligence and inventiveness. Tryst '20 one of the most acknowledged technical fest of India is intended to be an exceptional rejuvenating experience for the participants.\nWith Tryst '19 witnessing a multifold increase in it's outreach, Tryst 2020 does not plan to stop and aims to be the biggest and the best rendition of itself.\n\nVisit Tryst website for more details.";
String sponsorlink = "https://graphitegtc.com/index";
String trystlinkname = "tryst-iitd.org";
String trystlink = "https://tryst-iitd.org/";