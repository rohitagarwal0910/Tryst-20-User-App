import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:tryst_20_user/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          backgroundColorStart: Colors.indigo,
          backgroundColorEnd: Colors.cyan,
          title: Text('About'),
          centerTitle: true,
          // actions: <Widget>[ProfileIcon()],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            child: Column(
              children: <Widget>[
                // Expanded(child: Container()),
                Center(
                  child: Image.asset(
                    'assets/trystlogowhite.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Expanded(child: Container()),
                Center(
                  child: Text(
                    "sponsored by",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      // if (await canLaunch(sponsorlink)) {
                      launch(sponsorlink);
                      // } else {
                      // throw 'Could not launch url';
                      // }
                    },
                    child: Image.asset(
                      'assets/graphitelogo.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                ),
                Container(height: 40),
                Center(
                  child: Text(about,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      )),
                ),
                RaisedButton(
                  onPressed: () {
                    launch(trystlink);
                  },
                  child: Text(trystlinkname),
                )
              ],
            ),
          ),
        ));
  }
}
