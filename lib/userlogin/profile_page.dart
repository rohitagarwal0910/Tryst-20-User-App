import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:tryst_20_user/globals.dart';

import '../loading.dart';

class ProfilePage extends StatelessWidget {
  final Function onlogout;

  ProfilePage(this.onlogout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Colors.indigo,
        backgroundColorEnd: Colors.cyan,
        title: Text('Profile'),
        centerTitle: true,
        // actions: <Widget>[ProfileIcon()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (currentUser.photo_url != null && currentUser.photo_url.isNotEmpty)
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        height: 60,
                        child: Image.network(
                          currentUser.photo_url,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              currentUser.name,
              style: TextStyle(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Text(
              currentUser.email,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            FlatButton(
              onPressed: () async {
                // getToken();
                Navigator.pop(context);
                showLoading(context, message: "Signing Out");
                await logout();
                Navigator.pop(context);
                onlogout();
              },
              color: Colors.indigo[400],
              child: Text(
                'LOGOUT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future logout() async {
  final storage = new FlutterSecureStorage();
  await storage.delete(key: "email");
  await storage.delete(key: "password");
  await storage.delete(key: "token");
}
