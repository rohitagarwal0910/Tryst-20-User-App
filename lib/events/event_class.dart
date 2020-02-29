// import 'dart:convert';

// import 'package:tryst_20_user/clubs/club_class.dart';
// import 'package:dio/dio.dart';

List<List<String>> reg_type_list = [
  ["team", "Team"],
  ["single", "Single"]
];

List<List<String>> reg_mode_list = [
  ["website", "Website"],
  ["email", "Email"],
  ["external", "External"]
];

// List<List<String>> event_type_list = [
//   ["event", "Event"],
//   ["workshop", "Workshop"],
//   ["guest", "Guest"]
// ];

List<List<String>> dtv_type_list = [
  ["General", "General"],
  ["Prelims", "Prelims"],
  ["Finals", "Finals"]
];

class Event {
  String id, name, subheading, description, prizes;
  List<String> rules = [];

  EventCategory category;
  String category_name;
  String type = "guest";

  String probURL;

  bool registration = false;
  bool reg_status;
  DateTime reg_deadline;
  String reg_type;
  String reg_mode;
  String reg_email;
  String reg_link;
  int reg_min_team_size;
  int reg_max_team_size;
  int reg_count;

  List<poc> poc_details = [];

  List<List<String>> photos = [];

  List<dtv> dtv_details = [];

  String eventName;
  // Club eventBody;
  String venue = "LHC";
  DateTime startsAt;
  DateTime endsAt;
  String about;
  String imageLink;
  bool isStarred;
  bool isBodySub;
  String bodyid;
  String eventid;
  // List<Update> updates;

  Event({
    this.eventName,
    // this.eventBody,
    this.venue,
    this.about,
    DateTime start,
    DateTime end,
    this.bodyid,
    this.eventid,
    this.isStarred = false,
    this.isBodySub = false,
    this.imageLink = "",
    // this.updates
  }) {
    this.startsAt = (start == null) ? DateTime.now() : start;
    this.endsAt = (end == null) ? this.startsAt.add(Duration(days: 1)) : end;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    // // DateTime startDate = DateTime.parse(json["startDate"]).add(Duration(days: 2));
    // DateTime startDate = DateTime.parse(json["startDate"]);
    // DateTime endDate = (json.containsKey("endDate"))
    //     ? DateTime.parse(json["endDate"])
    //     : startDate.add(Duration(hours: 1));
    // return Event(
    //     eventName: json["name"], //
    //     eventBody: Club.fromJson(json["body"]), //
    //     imageLink: json.containsKey("image") ? json["image"] : "",
    //     start: startDate, //
    //     end: endDate,
    //     // updates: json["updates"],
    //     about: json["about"], //
    //     venue: json["venue"], //
    //     isStarred: json["stared"], //
    //     eventid: json["id"], //
    //     isBodySub: json["body"]["isSub"] //
    //     );
    print("Event from json start ${json["name"]}");
    Event newEvent = Event();
    newEvent.name = json["name"];
    newEvent.id = json["id"];
    newEvent.subheading = json["subheading"];
    newEvent.category_name = json["category_name"];
    newEvent.category = allCategories.firstWhere((t) {
      return t.id == json["category"];
    });
    newEvent.description = json["description"];
    json["rules"].forEach((r) {
      newEvent.rules.add(r);
    });
    newEvent.prizes = json["prizes"];
    if (newEvent.prizes != null)
      newEvent.prizes = newEvent.prizes.substring(17);
    newEvent.probURL = json["url"];
    for (int i = 0; i < json["dtv"].length; i++) {
      newEvent.dtv_details.add(dtv(
        day: json["dtv"][i]["date"],
        type: json["dtv"][i]["type"],
        start_time: DateTime.tryParse(json["dtv"][i]["start_time"]),
        end_time: DateTime.tryParse(json["dtv"][i]["end_time"]),
        venue: json["dtv"][i]["venue"],
      ));
    }
    newEvent.dtv_details.sort((a, b) {
      DateTime adate, bdate;
      adate = DateTime.parse(a.day);
      bdate = DateTime.parse(b.day);
      if (adate.isBefore(bdate))
        return -1;
      else
        return 1;
    });
    for (int i = 0; i < json["photos"].length; i++) {
      List<String> item = [];
      for (int j = 0; j < json["photos"][i].length; j++) {
        item.add(json["photos"][i][j]);
      }
      newEvent.photos.add(item);
    }
    for (int i = 0; i < json["poc"].length; i++) {
      newEvent.poc_details.add(poc(
        name: json["poc"][i]["name"],
        email: json["poc"][i]["email"],
        designation: json["poc"][i]["designation"],
        contact: json["poc"][i]["contact"],
      ));
    }
    newEvent.registration = json["reg_status"];
    if (json["reg_deadline"] != null)
      newEvent.reg_deadline = DateTime.tryParse(json["reg_deadline"]);
    if (json["reg_type"] != null) newEvent.reg_type = json["reg_type"];
    if (json["reg_mode"] != null) newEvent.reg_mode = json["reg_mode"];
    if (json["reg_link"] != null) newEvent.reg_link = json["reg_link"];
    if (json.containsKey("reg_min_team_size") &&
        json["reg_min_team_size"] != null)
      newEvent.reg_min_team_size = json["reg_min_team_size"];
    if (json.containsKey("reg_max_team_size") &&
        json["reg_max_team_size"] != null)
      newEvent.reg_max_team_size = json["reg_max_team_size"];
    return newEvent;
  }

  Map toMap() {
    String deadline;
    if (reg_deadline != null) {
      deadline = reg_deadline.toIso8601String();
      if (!deadline.endsWith("Z")) {
        deadline = deadline + "Z";
      }
    }
    return {
      // Map<String, dynamic> map = new Map<String, dynamic>();
      "name": name,
      "subheading": subheading,
      "category": category.id,
      "category_name": category_name,
      "type": type,
      "description": description,
      "rules": rules,
      "url": probURL,
      "prizes": (prizes != null) ? "Prizes worth Rs. " + prizes : null,
      "photos": photos,
      "registration": registration,
      "reg_type": reg_type,
      "reg_mode": reg_mode,
      "reg_deadline": (reg_deadline == null) ? null : deadline,
      "reg_link": reg_link,
      "reg_email": reg_email,
      "reg_min_team_size": reg_min_team_size,
      "reg_max_team_size": reg_max_team_size,
      "dtv": dtv_details.map((d) {
        return d.toMap();
      }).toList(),
      "poc": poc_details.map((d) {
        return d.toMap();
      }).toList(),
    };
    // map["dis"] = about;
    // map["startDate"] = startsAt.toIso8601String() + "Z";
    // map["endDate"] = endsAt.toIso8601String() + "Z";
    // map["venue"] = venue;
    // map["body"] = eventBody.id;
    // map["imageLink"] = imageLink;
    // return map;
  }

  Map toMapForUpdate() {
    String deadline;
    if (reg_deadline != null) {
      deadline = reg_deadline.toIso8601String();
      if (!deadline.endsWith("Z")) {
        deadline = deadline + "Z";
      }
    }
    return {
      // Map<String, dynamic> map = new Map<String, dynamic>();
      "name": name,
      "subheading": subheading,
      "category": category.id,
      "category_name": category_name,
      "type": type,
      "description": description,
      "rules": rules,
      "prizes": (prizes != null) ? "Prizes worth Rs. " + prizes : null,
      "url": probURL,
      "photos": photos,
      "registration": registration,
      // "reg_type": reg_type,
      "reg_mode": reg_mode,
      "reg_deadline": (reg_deadline == null) ? null : deadline,
      "reg_link": reg_link,
      "reg_email": reg_email,
      // "reg_min_team_size": reg_min_team_size,
      // "reg_max_team_size": reg_max_team_size,
      "dtv": dtv_details.map((d) {
        return d.toMap();
      }).toList(),
      "poc": poc_details.map((d) {
        return d.toMap();
      }).toList(),
    };
    // map["dis"] = about;
    // map["startDate"] = startsAt.toIso8601String() + "Z";
    // map["endDate"] = endsAt.toIso8601String() + "Z";
    // map["venue"] = venue;
    // map["body"] = eventBody.id;
    // map["imageLink"] = imageLink;
    // return map;
  }
}

class dtv {
  String name, type, day, venue;
  DateTime start_time, end_time;

  dtv(
      {this.name,
      this.type,
      this.day,
      this.start_time,
      this.end_time,
      this.venue});

  @override
  String toString() {
    return "Day: $type\n"
        "Starts: ${start_time.toString()}\n"
        "Starts: ${end_time.toString()}\n";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    String start = start_time.toIso8601String();
    if (!start.endsWith("Z")) {
      start = start + "Z";
    }
    String end = end_time.toIso8601String();
    if (!end.endsWith("Z")) {
      end = end + "Z";
    }
    map["type"] = type;
    map["date"] = day;
    map["start_time"] = start;
    map["end_time"] = end;
    map["venue"] = venue;
    return map;
  }
}

// class photo {
//   String url, heading, description;

//   photo()
// }

class poc {
  String email, name, designation, contact;

  poc({this.name, this.email, this.designation, this.contact});

  @override
  String toString() {
    return "Name: $name\n"
        "Email: $email\n"
        "Designation: $designation\n"
        "Contact: $contact\n";
  }

  // Map<String, dynamic> toMap() {
  //   Map<String, dynamic> map = new Map<String, dynamic>();
  //   map["name"] = name;
  //   map["email"] = email;
  //   map["designation"] = designation;
  //   map["contact"] = contact;
  //   return map;
  // }

  toMap() {
    return {
      "name": this.name,
      "email": this.email,
      "designation": this.designation,
      "contact": this.contact
    };
  }
}

class EventDay {
  Event event;
  dtv schedule;
  EventDay(this.event, this.schedule);
}

class EventCategory {
  String name, id;

  EventCategory({this.name, this.id});
}

EventCategory workshop = EventCategory(name: "Workshop", id: "Workshops");
EventCategory competition =
    EventCategory(name: "Competition", id: "Competitions");
EventCategory flagship = EventCategory(name: "Flagship", id: "Flagship");
EventCategory exhibition = EventCategory(name: "Exhibition", id: "Exhibitions");
EventCategory guest =
    EventCategory(name: "Guest Lecture", id: "Guest Lectures");

List<EventCategory> allCategories = [
  workshop,
  competition,
  flagship,
  exhibition,
  guest
];
