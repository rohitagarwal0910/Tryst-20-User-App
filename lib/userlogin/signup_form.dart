import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tryst_20_user/error_alert.dart';
import 'package:tryst_20_user/user_class.dart';
// import 'package:tryst_20_user/userlogin/login_page.dart';
import 'package:validators/validators.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:tryst_20_user/globals.dart';
import 'package:tryst_20_user/loading.dart';
import '../cancel_alert.dart';
import '../globals.dart';

class SignUpForm extends StatefulWidget {
  final Function onlogin;

  SignUpForm(this.onlogin);

  @override
  State<StatefulWidget> createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  String name;
  String emailId;
  String password;
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

  final _key = GlobalKey<FormState>();

  Future makeUser() async {
    print("Signing Up");

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    String _url = '$url/api/user/create';

    Map bodyMap = {
      "email": emailId,
      "name": name,
      "password": password,
      "phone": phoneno,
      "address": address,
      "university": university,
      "role": "normal",
      "year": year,
      "gender": gender,
      "photo_url": photo_url,
      "dob": dob.toIso8601String() + "Z",
    };

    print(bodyMap.toString());

    HttpClientRequest request = await client.postUrl(Uri.parse(_url));

    request.headers.set('content-type', 'application/json');

    // request.headers.add(headerKey, token);

    request.add(utf8.encode(json.encode(bodyMap)));

    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();

    // final response = await http.post("$url/api/user/adminCreate",
    //     // body: {"email": emailId, "name": name, "password": password}
    //     body: {
    //         "email": emailId,
    //         "name": name,
    //         "password": password,
    //         "phone": phoneno,
    //         "address": address,
    //         "university": university,
    //         "role": role,
    //         "year": year,
    //         "gender": gender,
    //         "dob": dob.toString(),
    //         "adminSecret" : admin_secret
    //     });
    // print(response.body);
    print(response.statusCode);
    if (reply == "Username or Email Is Already In Use") {
      Navigator.pop(context);
      showErrorAlert(context, "Email already registered",
          "This email is already registered. Use another email.");
      return;
    }
    var parsedJson = json.decode(reply);
    if (response.statusCode == 200) {
      print("success");
      // if (parsedJson["message"] == "Registration Successful") {
      Navigator.pop(context);
      await showErrorAlert(context, "Success",
          "Verification e-mail sent to $emailId. Login to your account after verification.",
          command: "CONTINUE");
      // showLoading(context);
      // await login(context, emailId, password, widget.onlogin);
      Navigator.pop(context);
      // } else if (response.statusCode == 401){
      //   Navigator.pop(context);
      //   print("error");
      //   showErrorAlert(context, "Sign Up Failed", parsedJson["message"]);
    } else {
      Navigator.pop(context);
      print("error");
      showErrorAlert(context, "Sign Up Failed", parsedJson["message"]);
    }
    // } else {
    //   Navigator.pop(context);
    //   print("error");
    //   showErrorAlert(context, "Sign Up Failed",
    //       "Please check your details and try again.");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Enter Name*',
                  helperText: ''),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                name = text;
              },
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'e-mail address*',
                  helperText: ''),
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                emailId = text;
              },
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else if (isEmail(text))
                  return null;
                else
                  return ("Not a valid e-mail id");
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Make a Password*',
                  helperText: ''),
              onSaved: (text) {
                password = text;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Confirm Password*',
                  helperText: ''),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(color: Colors.white),
              validator: (text) {
                if (text != password)
                  return 'Does not match';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Phone Number*',
                  helperText: ''),
              onSaved: (text) {
                phoneno = text;
              },
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white),
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Address*',
                  helperText: ''),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                address = text;
              },
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'University*',
                  helperText: ''),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                university = text;
              },
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true, labelText: 'Year*', helperText: ''),
              keyboardType: TextInputType.number,
              maxLines: null,
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                year = text;
              },
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              validator: (text) {
                if (text.isEmpty)
                  return 'Required';
                else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Profile Picture Link',
                  helperText: ''),
              keyboardType: TextInputType.url,
              maxLines: null,
              style: TextStyle(color: Colors.white),
              onSaved: (text) {
                photo_url = text;
              },
              validator: (text) {
                if (text.isEmpty)
                  return null;
                else if (!isURL(text))
                  return 'Not a valid link';
                else
                  return null;
              },
            ),
            DateTimeField(
              // inputType: InputType.both,
              format: DateFormat("d MMMM, yyyy"),
              readOnly: true,
              // editable: false,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime(2000),
                    lastDate: DateTime(2100));
                if (date != null) {
                  return date;
                } else {
                  return currentValue;
                }
              },
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Date of Birth*',
                  hasFloatingPlaceholder: true,
                  helperText: ''),
              style: TextStyle(color: Colors.white),
              onChanged: (dt) {
                dob = dt;
              },
              onSaved: (dt) {
                dob = dt;
              },
              validator: (dt) {
                if (dt == null)
                  return 'Required';
                else
                  return null;
              },
            ),
            DropdownButtonFormField<String>(
              // hint: Text("Select Club"),
              value: gender,
              items: [
                DropdownMenuItem<String>(
                  value: "Male",
                  child: Text(
                    "Male",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Female",
                  child: Text(
                    "Female",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Prefer not to say",
                  child: Text(
                    "Prefer not to say",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              validator: (value) {
                if (value == null ?? true)
                  return 'Required';
                else
                  return null;
              },
              onSaved: (value) {
                gender = value;
              },
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Gender*",
                helperText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            // DropdownButtonFormField<String>(
            //   // hint: Text("Select Club"),
            //   value: role,
            //   items: user_role.map((r) {
            //     return DropdownMenuItem(
            //       value: r[0],
            //       child: Text(r[1]),
            //     );
            //   }).toList(),
            //   validator: (value) {
            //     if (value == null ?? true)
            //       return 'Required';
            //     else
            //       return null;
            //   },
            //   onSaved: (value) {
            //     role = value;
            //   },
            //   decoration: InputDecoration(
            //     alignLabelWithHint: true,
            //     labelText: "Role*",
            //     helperText: '',
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //   ),
            //   onChanged: (value) {
            //     setState(() {
            //       role = value;
            //     });
            //   },
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       alignLabelWithHint: true,
            //       labelText: 'Admin Secret',
            //       helperText: 'For registering as an admin'),
            //   keyboardType: TextInputType.multiline,
            //   obscureText: true,
            //   maxLines: 1,
            //   style: TextStyle(color: Colors.white),
            //   onSaved: (text) {
            //     admin_secret = text;
            //   },
            //   validator: (text) {
            //     // if (text.isEmpty)
            //     //   return 'Required';
            //     // else
            //     return null;
            //   },
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       alignLabelWithHint: true,
            //       labelText: 'SBI Account Number',
            //       helperText: ''),
            //   keyboardType: TextInputType.multiline,
            //   maxLines: null,
            //   style: TextStyle(color: Colors.white),
            //   onSaved: (text) {
            //     name = text;
            //   },
            //   validator: (text) {
            //     // if (text.isEmpty)
            //     //   return 'Required';
            //     // else
            //       return null;
            //   },
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       alignLabelWithHint: true,
            //       labelText: 'IFSC Code',
            //       helperText: ''),
            //   keyboardType: TextInputType.multiline,
            //   maxLines: null,
            //   style: TextStyle(color: Colors.white),
            //   onSaved: (text) {
            //     name = text;
            //   },
            //   validator: (text) {
            //     // if (text.isEmpty)
            //     //   return 'Required';
            //     // else
            //       return null;
            //   },
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       alignLabelWithHint: true,
            //       labelText: 'Account Holder Name',
            //       helperText: ''),
            //   keyboardType: TextInputType.multiline,
            //   maxLines: null,
            //   style: TextStyle(color: Colors.white),
            //   onSaved: (text) {
            //     name = text;
            //   },
            //   validator: (text) {
            //     // if (text.isEmpty)
            //     //   return 'Required';
            //     // else
            //       return null;
            // },
            // ),
            Container(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      showCancelAlert(context, 'Cancel Sign-Up?',
                          'Are you sure you want to cancel making new account?');
                    },
                    child: Text('CANCEL'),
                    color: Colors.indigo[400],
                  ),
                ),
                Container(width: 10,),
                Expanded(
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _key.currentState.save();
                      if (_key.currentState.validate()) {
                        showLoading(context);
                        await makeUser();
                      }
                    },
                  ),
                ),
              ],
            ),
            Container(height: 5),
            Text(
              "Details cannot be changed later.",
              style: TextStyle(color: Colors.white60),
            ),
            Container(height: 15)
          ],
        ),
      ),
    );
  }
}
