import 'dart:convert';
import 'dart:ui';
import 'package:estore/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:estore/constants.dart';
import 'dart:math' as math;

class UploadRack extends StatefulWidget {
  final String pid;

  const UploadRack({
    required Key key,
    required this.pid,
  }) : super(key: key);

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<UploadRack> {
  late SharedPreferences sharedPreferences;

  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[50],
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: Image(
                image: AssetImage("assets/martlogo.png"),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Container(
          //     padding: EdgeInsets.only(top: 20, right: 20),
          //     child: Text(
          //       "+ Cities",
          //       style: TextStyle(color: Colors.grey),
          //     )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.red[50],
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/rack.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          child: Text(
                            "Rack  ",
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: emailController,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Name ",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
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
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () async {
                        String name = emailController.text.trim();
                        Map data = {
                          'name': name,
                          'cid': widget.pid,
                          'aid': '',
                          'noofcont': '0'
                        };
                        var jsonResponse = null;
                        var url = Uri.parse("${BASE_URL}api/rack/add");
                        var response = await http.post(url, body: data);

                        if (response.statusCode == 200) {
                          jsonResponse = json.decode(response.body);
                          print(jsonResponse);
                          if (jsonResponse != null) {
                            Fluttertoast.showToast(
                              msg: "Added!",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            sharedPreferences.setString(
                                "uid", jsonResponse['_id']);
                            sharedPreferences.setString("type", "client");

                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                            //     (Route<dynamic> route) => false);
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "${json.decode(response.body)}",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          print("The error message is: ${response.body}");
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 2, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(1.0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.only(top: 0),
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3),
                                        child: DefaultTextStyle(
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            child: Text(
                                              "Add ",
                                            )),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ))
                ],
              ),
            ),
          ]),
        ),
      ));
}
