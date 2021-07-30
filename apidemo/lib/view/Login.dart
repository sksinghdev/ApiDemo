import 'dart:convert';

import 'package:apidemo/locale/application_localizations.dart';
import 'package:apidemo/view/dahboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum state { YES, NO }

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool isLoggedIn = false;
  String userName = '';
  String passwordValue = '';
  state loading = state.NO;

  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isLogin') ?? false;
    if (status) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    } else {
      setState(() {
        loading = state.YES;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading == state.YES
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 80,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          userName = text;
                          if (validateString(userName) &&
                              validateString(passwordValue)) {
                            isLoggedIn = true;
                          } else {
                            isLoggedIn = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate('username'),
                          hintText: ''),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    //padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          passwordValue = text;
                          if (validateString(userName) &&
                              validateString(passwordValue)) {
                            isLoggedIn = true;
                          } else {
                            isLoggedIn = false;
                          }
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate('password'),
                          hintText: ''),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(isLoggedIn ? 1.0 : 0.2),
                        borderRadius: BorderRadius.circular(30)),
                    child: FlatButton(
                      onPressed: () {
                        if (!validateUserNamePassword(
                            userName, "User name ", 10)) {
                        } else if (!validateUserNamePassword(
                            passwordValue, "Password ", 11)) {
                        } else if (validateUserPassword(userName) &&
                            validateUserPassword(passwordValue)) {
                          print('calling to save and next view ');
                          saveLogin(true);
                        } else {
                          showMessage(
                              '${AppLocalizations.of(context).translate('invalid_password')}');
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('login'),
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: SpinKitPulse(
                color: Colors.black,
                size: 50.0,
              ),
            ),
    );
  }

  validateString(String value) {
    print('value $value');
    if (value == null || value.isEmpty) {
      return false;
    } else {
      print('calling else ');
      return true;
    }
  }

  validateUserPassword(String value) {
    if (value == null || value.isEmpty) {
      return false;
    } else if (value == "9898989898" ||
        value == "password123" ||
        value == "9876543210") {
      return true;
    } else {
      return false;
    }
  }

  validateUserNamePassword(String vale, String message, int maxLenght) {
    if (vale.isEmpty) {
      showMessage(
          "${message} ${AppLocalizations.of(context).translate('not_empty')}");
      return false;
    } else if (vale.length <= 3) {
      showMessage(
          "${message} ${AppLocalizations.of(context).translate('lessthan3')}");
      return false;
    } else if (vale.length > maxLenght) {
      showMessage(
          "${message} ${AppLocalizations.of(context).translate('not_greater')} ${maxLenght} ${AppLocalizations.of(context).translate('character')}");
      return false;
    } else {
      return true;
    }
  }

  showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  saveLogin(bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', isLogin);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashBoard()),
    );
  }
}
