import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:tryst_20_user/user_class.dart';
import 'package:tryst_20_user/userlogin/signup_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:validators/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../loading.dart';
import '../globals.dart';
import '../error_alert.dart';

Future login(
    BuildContext context, String _email, String _password, Function onlogin,
    {bool pop = true}) async {
  print("loggin in");

  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  String _url = '$url/api/user/login';
  Map map = {"email": _email, "password": _password};
  // try{
  HttpClientRequest request = await client.postUrl(Uri.parse(_url));
  request.headers.set('content-type', 'application/json');

  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse _response = await request.close();
  String response = await _response.transform(utf8.decoder).join();

  print(response);

  // final response = await http.post("$url/api/user/login",
  //     body: {"email": _email, "password": _password});
  // print(response.body);
  print("response code ${_response.statusCode}");
  Map<String, dynamic> parsedJson = json.decode(response);
  if (_response.statusCode == 200) {
    // if (parsedJson.containsKey("errors")) {
    //   print("Code 200 but has errors");
    //   if(pop) Navigator.pop(context);
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Wrong email id or password. Try Again"),
    //   ));
    //   return;
    // }
    // if (parsedJson["message"] == "Login Successful") {
    final storage = new FlutterSecureStorage();
    token = parsedJson["data"]["token"];
    // final _response = await http
    // .get("$url/api/user/me", headers: {"x-auth-token": "$token"});
    // if (_response.statusCode == 200) {
    // var parsedJson = json.decode(_response.body);
    currentUser = User.fromJson(parsedJson["data"]["user"]);
    print("Login successful");
    print("token : $token");
    await storage.write(key: "email", value: _email);
    await storage.write(key: "password", value: _password);
    await storage.write(key: "token", value: token);
    if (pop) Navigator.pop(context);
    onlogin();
  } else if (_response.statusCode == 401 || _response.statusCode == 500) {
    if (pop) Navigator.pop(context);
    showErrorAlert(context, "Login Failed", parsedJson["message"]);
  } else {
    if (pop) Navigator.pop(context);
    showErrorAlert(context, "Login Failed", "Something went wrong. Try again");
  }
  // }
  // on SocketException catch (_) {
  //   showErrorAlert(context, "Login Failed", "Timeout Exception");
  // }
}

Future forgotPassword(
  BuildContext context,
  String _email,
) async {
  bool pop = true;
  // print("loggin in");

  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  String _url = '$url/api/user/forgot';
  Map map = {
    "email": _email,
  };
  // try{
  HttpClientRequest request = await client.postUrl(Uri.parse(_url));
  request.headers.set('content-type', 'application/json');

  request.add(utf8.encode(json.encode(map)));
  HttpClientResponse _response = await request.close();
  String response = await _response.transform(utf8.decoder).join();

  print(response);

  // final response = await http.post("$url/api/user/login",
  //     body: {"email": _email, "password": _password});
  // print(response.body);
  print("response code ${_response.statusCode}");
  Map<String, dynamic> parsedJson = json.decode(response);
  if (_response.statusCode == 200) {
    if (pop) Navigator.pop(context);
    if (pop) Navigator.pop(context);
    showErrorAlert(context, "Success", "Password reset link sent to $_email");
  } else if (_response.statusCode == 401 || _response.statusCode == 500) {
    if (pop) Navigator.pop(context);
    if (pop) Navigator.pop(context);
    showErrorAlert(context, "Failed", parsedJson["message"]);
  } else {
    if (pop) Navigator.pop(context);
    if (pop) Navigator.pop(context);
    showErrorAlert(context, "Failed", "Something went wrong. Try again");
  }
}

class LoginPage extends StatefulWidget {
  final Function onlogin;

  LoginPage({this.onlogin});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  String _email;
  String _password;

  Future<bool> showForgotPasswordAlert(
      BuildContext context, String title, String message,
      {String command = "OK"}) {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.indigo[600],
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    // Navigator.of(context).pop(false);
                    showLoading(context);
                    forgotPassword(context, _email);
                  },
                  child: Text(
                    command,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    child: Center(child:Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w200),
                  ),)
                  ),
                  Form(
                    key: _key,
                    child: Wrap(
                      // direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 9,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "email-id",
                            helperText: '',
                            enabled: true,
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.04),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red[700])),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (text) {
                            _email = text;
                          },
                          validator: (text) {
                            if (text.isEmpty)
                              return 'Required';
                            else if (isEmail(text))
                              return null;
                            else
                              return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.04),
                            helperText: '',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white30)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red[700])),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          onSaved: (text) {
                            _password = text;
                          },
                          validator: (text) {
                            return (text.isEmpty) ? 'Required' : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      child: Text("LOGIN"),
                      color: Colors.indigo[400],
                      onPressed: () async {
                        if (_key.currentState.validate()) {
                          _key.currentState.save();
                          showLoading(context);
                          await login(
                              context, _email, _password, widget.onlogin);
                          // widget.onlogin();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      color: Colors.indigo[600],
                      onPressed: () async {
                        _key.currentState.save();
                        if (_email.isNotEmpty)
                          showForgotPasswordAlert(context, "Forgot Password",
                              "Press OK to receive email containing password reset link at $_email");
                        else
                          showErrorAlert(context, "Forgot Password",
                              "If you have forgot password for your account then enter the email address in the login form and then press forgot password button to recieve email for resetting password.");
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.white70,
                            height: 30,
                          ),
                        ),
                        Text(
                          " OR ",
                          style: TextStyle(wordSpacing: 10),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white70,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FlatButton(
                      child: Text("SIGN UP"),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUpPage(widget.onlogin)));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // return Text("loading");
  // },
  // );
  // }
}
