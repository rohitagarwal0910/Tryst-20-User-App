import 'package:flutter/material.dart';
import 'package:tryst_20_user/userlogin/profile_page.dart';

import './profile_dialog.dart';

class ProfileIcon extends StatelessWidget {
  final Function onlogout;

  ProfileIcon(this.onlogout);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person),
    //   onPressed: () {Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ProfilePage(onlogout)));}
    // );
    onPressed: () {showAlert(context, onlogout);},
    );
  }
}