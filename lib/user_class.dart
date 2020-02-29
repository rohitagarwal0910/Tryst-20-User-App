// import './clubs/club_class.dart';

List<List<String>> user_role = [
  ["normal", "Normal"],
  ["hospi", "Admin - Hospitality"],
  ["event", "Admin - Events"],
  ["workshop", "Admin - Workshops"],
  ["guest", "Admin - Guests"],
  ["super", "Super Admin"],
  ["ac-head", "Activity Head"]
];

class User {
  String name, id;
  String email;
  // String password;
  String phoneno;
  String address;
  String university,
      photo_url,
      year,
      gender,
      sbi_acc_no,
      ifsc_code,
      account_holder_name,
      role,
      admin_secret;
  DateTime dob;
  bool isAdmin = false;
  // List<UClub> adminof;
  bool isSuperAdmin = false;
  // List<UClub> superAdminOf;
  // bool isSSAdmin;

  User({
    this.name,
    this.email,
    this.id,
    this.phoneno,
    this.address,
    this.photo_url,
    this.account_holder_name,
    this.gender,
    this.ifsc_code,
    this.sbi_acc_no,
    this.university,
    this.year,
    this.dob
    // this.isAdmin,
    // this.adminof,
    // this.isSuperAdmin,
    // this.superAdminOf,
    // this.isSSAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // print("ADMINOF LENGTH: ${json["adminOf"].length}");
    // bool iA = (json["adminOf"].length + json["superAdminOf"].length > 0)
    //     ? true
    //     : false;
    // bool iSA = (json["superAdminOf"].length > 0) ? true : false;
    // // bool iSA = false;
    // List<UClub> adminof = List<UClub>();
    // for (int i = 0; i < json["adminOf"].length; i++) {
    //   adminof.add(UClub.fromJson(json["adminOf"][i]));
    // }
    // List<UClub> superadminof = List<UClub>();
    // for (int i = 0; i < json["superAdminOf"].length; i++) {
    //   adminof.add(UClub.fromJson(json["superAdminOf"][i]));
    //   superadminof.add(UClub.fromJson(json["superAdminOf"][i]));
    // }
    return User(
      name: json["name"],
      email: json["email"],
      id: json["id"],
      phoneno: json["phone"],
      photo_url: json["photo_url"],
      account_holder_name: json["account_holder_name"],
      address: json["address"],
      gender: json["gender"],
      // dob: json["dob"],
      ifsc_code: json["ifsc_code"],
      university: json["university"],
      sbi_acc_no: json["sbi_acc_no"],
      year: json["year"],
      // isAdmin: iA,
      // isSuperAdmin: iSA,
      // adminof: adminof,
      // superAdminOf: superadminof,
    );
  }
}

// User currentUser = User('DummyUser', true, [], true, []);
// class UClub extends Club {
//   String clubName;
//   String id;

//   UClub({this.clubName, this.id});

//   factory UClub.fromJson(Map<String, dynamic> json) {
//     return UClub(
//       clubName: json["name"],
//       id: json["_id"],
//     );
//   }
// }

class Admin extends User {
  String name;
  String email;
  String id;

  Admin({this.name, this.email, this.id});

  factory Admin.fromJson(Map<String, dynamic> json) {
    String name =
        (json.containsKey("name")) ? json["name"] : "Test ${json["email"]}";
    return Admin(name: name, email: json["email"], id: json["_id"]);
  }
}
