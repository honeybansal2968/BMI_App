import 'package:estore/checkin.dart';
import 'package:estore/client.dart';
import 'package:estore/constants.dart';
import 'package:estore/driver.dart';
import 'package:estore/home.dart';
import 'package:estore/security.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static String routeName = "/splash";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  String dropdownValue = 'Client';
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = "driver@gmail.com";
    passController.text = "driver123";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue[50],
          width: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 300,
              ),
              Container(
                color: Colors.blue[50],
                height: 160,
                child: const Image(
                  image: AssetImage("assets/martlogo.png"),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "UserName ",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 213, 160, 160),
                        //   shadows: [
                        //   Shadow(
                        //     blurRadius: 2.0,
                        //     color: Colors.teal,
                        //     offset: Offset(1.0, 1.0),
                        //   ),
                        // ],
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: passController,
                  obscureText: hideconpass,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: const UnderlineInputBorder(),
                      hintText: "Password",
                      suffixIcon: InkWell(
                        onTap: () {
                          if (hideconpass == true) {
                            hideconpass = false;
                          } else {
                            hideconpass = true;
                          }
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.visibility,
                        ),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    child: const Text(
                      "Type :",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? migratevalue) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = migratevalue!;
                      });
                    },
                    // onChanged: (value) {

                    // },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  color: const Color(0xFF007b34),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String pass = passController.text.trim();
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          Map data = {
                            'email': email,
                            'password': pass,
                          };

                          if (dropdownValue == "Client") {
                            var jsonResponse;
                            var url = Uri.parse("${BASE_URL}api/client/login");
                            var response = await http.post(url, body: data);

                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);
                                sharedPreferences.setString("type", "client");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ClientScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }

                          if (dropdownValue == "Manager") {
                            var jsonResponse;
                            var url = Uri.parse("$BASE_URL/api/manager/login");
                            var response = await http.post(url, body: data);
                            print("response $response");
                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);

                                sharedPreferences.setString("type", "manager");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ClientScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }

                          if (dropdownValue == "Driver") {
                            var jsonResponse;
                            var url = Uri.parse("${BASE_URL}api/driver/login");
                            var response = await http.post(url, body: data);

                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);
                                sharedPreferences.setString("type", "driver");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CheckInScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }

                          if (dropdownValue == "Security") {
                            var jsonResponse;
                            var url =
                                Uri.parse("${BASE_URL}api/security/login");
                            var response = await http.post(url, body: data);

                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);
                                sharedPreferences.setString("type", "security");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SecurityScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
