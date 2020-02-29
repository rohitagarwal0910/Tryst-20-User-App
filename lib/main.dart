import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'globals.dart';
import 'user_class.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'error_alert.dart';
import 'home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userlogin/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool signedIn;
  bool start;
  // bool splash = true;
  Future splash;

  void onlogin() {
    print("logged in");
    setState(() {
      signedIn = true;
    });
  }

  void onlogout() {
    print("logged out");
    setState(() {
      signedIn = false;
    });
  }

  Future checklogin() async {
    await splash;
    print("Checking login");
    final storage = new FlutterSecureStorage();
    String tempEmail = await storage.read(key: "email");
    String tempPass = await storage.read(key: "password");
    print("Saved email: $tempEmail");
    if (tempEmail == null) {
      print("Not logged in");
      return;
    } else {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      String _url = '$url/api/user/login';

      Map bodyMap = {
        "email" : tempEmail,
        "password" : tempPass
      };

      HttpClientRequest request = await client.postUrl(Uri.parse(_url));

      request.headers.set('content-type', 'application/json');

      // request.headers.add(headerKey, token);

      request.add(utf8.encode(json.encode(bodyMap)));

      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      // final loginresponse = await http.post("$url/api/user/login",
      //     body: {"email": tempEmail, "password": tempPass});

      if (response.statusCode == 200) {
        var parsedJson = json.decode(reply);
        token = parsedJson["data"]["token"];
        print(token);
        currentUser = User.fromJson(parsedJson["data"]["user"]);
      } else {
        showErrorAlert(context, "Session Expired", "Please Login Again");
      }
      print("already logged in");
      signedIn = true;
      // final response = await http
      //     .get("$url/api/user/login", headers: {"authorization": "Bearer $token"});
      // if (response.statusCode == 200) {
      // print(response.body);
      // }
    }
    // });
  }

  @override
  void initState() {
    super.initState();
    eventsList = [];
    print("startup");
    splash = Future.delayed(const Duration(seconds: 1, milliseconds: 50), (){});
    start = true;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("fcm token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            hintColor: Colors.white54,
            scaffoldBackgroundColor: Colors.indigo[900],
            canvasColor: Colors.indigo[700],
            brightness: Brightness.dark,
            cardColor: Colors.indigo,
            accentColor: Colors.lightBlueAccent),
        title: '$title',
        home: (start == true)
            ? FutureBuilder(
                future: checklogin(),
                builder: (context, snapshot) {
                  start = false;
                  if (snapshot.connectionState == ConnectionState.done) {
                    Widget home;
                    if (signedIn == true)
                      home = HomeScreen(onlogout: onlogout);
                    else
                      home = LoginPage(onlogin: onlogin);
                    return home;
                  }
                  return Scaffold(
                    backgroundColor: Colors.indigo[600],
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Expanded(child: Container()),
                            Image.asset('assets/trystlogowhite.png', width: MediaQuery.of(context).size.width*0.7,),
                            Text(
                              title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Expanded(child: Container()),
                            Text(
                              "sponsored by",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(
                              height: 3,
                            ),                            
                            Image.asset('assets/graphitelogo.png', width: MediaQuery.of(context).size.width*0.5,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : (signedIn == true)
                ? HomeScreen(onlogout: onlogout)
                : LoginPage(onlogin: onlogin));
  }

}