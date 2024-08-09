import 'dart:convert';
import 'dart:ui';
import 'package:estore/addbox.dart';
import 'package:estore/addfile.dart';
import 'package:estore/filedetail.dart';
import 'package:estore/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class Files extends StatefulWidget {
  final String pid;
  final String sid;
  final int box;

  const Files({
    Key? key,
    required this.pid,
    required this.sid,
    required this.box,
  }) : super(key: key);

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<Files> {
  late SharedPreferences sharedPreferences;
  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/packages/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    setState(() {
      productdetails = json.decode(presponse.body);
    });
  }

  @override
  void initState() {
    super.initState();

    getHttp();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.green[50],
        elevation: 0,
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
          // GestureDetector(
          //   onTap: (){
          //
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(
          //         builder: (context) =>
          //             AddFile()
          //     ));
          //   },
          //
          //   child:
          // Container(
          //     padding: EdgeInsets.only(top: 20, right: 20),
          //     child: Text(
          //       "+ Files",
          //       style: TextStyle(color: Colors.grey),
          //     )),),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddBox(
                        pid: widget.pid,
                        sid: widget.sid,
                        box: widget.box,
                      )));
            },
            child: Container(
                padding: EdgeInsets.only(top: 20, right: 20),
                child: Text(
                  "+ Box",
                  style: TextStyle(color: Colors.grey),
                )),
          ),
          // GestureDetector(
          //   onTap: (){
          //
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(
          //         builder: (context) =>
          //             AddBox(pid: widget.pid, sid: widget.sid,)
          //     ));
          //   },
          //
          //   child:
          //   Container(
          //       padding: EdgeInsets.only(top: 20, right: 20),
          //       child: Text(
          //         "Delete Box",
          //         style: TextStyle(color: Colors.red),
          //       )),)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.green[50],
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
              color: Colors.green[50],
              height: MediaQuery.of(context).size.height - 120,
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
                  Container(
                    height: MediaQuery.of(context).size.height - 270,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Container(
                      child: Column(
                        children: [
                          GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              physics: ScrollPhysics(),
                              itemCount: productdetails.length,
                              itemBuilder: (BuildContext context, int iindex) {
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         FileDetails()
                                    // ));
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(
                                        top: 2, left: 5, right: 5),
                                    // decoration: BoxDecoration(
                                    //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        padding: EdgeInsets.only(top: 0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                      height: 50,
                                                      child: Image(
                                                        image: AssetImage(
                                                            "assets/boxy.png"),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ));
}
