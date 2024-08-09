import 'dart:convert';
import 'dart:ui';
import 'package:estore/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:estore/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class AddSlab extends StatefulWidget {
  final String pid;

  const AddSlab({
    Key? key,
    required this.pid,
  }) : super(key: key);
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<AddSlab> {
  late SharedPreferences sharedPreferences;

  TextEditingController emailController = new TextEditingController();
  TextEditingController capController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
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
        titleSpacing: 0,
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
            color: Colors.green[100],
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/slab.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(13),
                  //   ),
                  //   child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               currentPage = 0;
                  //             });
                  //           },
                  //           child: AnimatedContainer(
                  //             duration: Duration(milliseconds: 200),
                  //             margin: EdgeInsets.only(right: 5),
                  //             height: 30,
                  //             width: MediaQuery.of(context).size.width / 4 - 20,
                  //             decoration: BoxDecoration(
                  //               color: currentPage == 0
                  //                   ? Colors.pink[200]
                  //                   : Colors.black,
                  //               borderRadius: BorderRadius.circular(13),
                  //             ),
                  //             child: Align(
                  //                 alignment: Alignment.center,
                  //                 child: Text(
                  //                   "Coins",
                  //                   style:
                  //                   TextStyle(fontSize: 10, color: Colors.black, fontWeight:FontWeight.bold),
                  //                 )),
                  //           ),
                  //         ),
                  //
                  //       ]),
                  // ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          child: Text(
                            "Add Slab  ",
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

                  Container(
                    height: 65,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: capController,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Capacity ",
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
                  GestureDetector(
                      onTap: () async {
                        String name = emailController.text.trim();
                        String cap = capController.text.trim();

                        print(widget.pid);
                        Map data = {
                          'name': name,
                          'tid': widget.pid,
                          'cap': int.parse(cap),
                          'box': 0
                        };
                        var jsonResponse = null;
                        var url = Uri.parse(
                          "${BASE_URL}api/rack/addstory?id=" + widget.pid,
                        );
                        var response = await http.post(url,
                            headers: {"Content-Type": "application/json"},
                            body: json.encode(data));

                        if (response.statusCode == 200) {
                          jsonResponse = json.decode(response.body);
                          print(jsonResponse);
                          if (jsonResponse != null) {
                            Fluttertoast.showToast(
                              msg: "Added!",
                              toastLength: Toast.LENGTH_SHORT,
                            );

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
