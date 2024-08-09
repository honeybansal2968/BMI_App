import 'dart:convert';
import 'dart:ui';
import 'package:estore/QRView.dart';
import 'package:estore/addbox.dart';
import 'package:estore/addcontainer.dart';
import 'package:estore/addrack.dart';
import 'package:estore/addslab.dart';
import 'package:estore/files.dart';
import 'package:estore/rack.dart';
import 'package:estore/search.dart';
import 'package:estore/uploadexcel.dart';
import 'package:estore/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class PackageScreen extends StatefulWidget {
  final String pid;

  const PackageScreen({
    Key? key,
    required this.pid,
  }) : super(key: key);

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<PackageScreen> {
  late SharedPreferences sharedPreferences;
  var productdetails;
  var storedetails;
  var boxdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/rack/getid?id=${widget.pid}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    print("hone : ${json.decode(sresponse.body)}");

    setState(() {
      productdetails = json.decode(sresponse.body);
    });
  }

  Future getStory(id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/store/getid?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      storedetails = json.decode(sresponse.body);
    });
  }

  Future getBox(id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/box/getid?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      boxdetails = json.decode(sresponse.body);
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    getHttp();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[50],
          elevation: 0,
          titleSpacing: 0,
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: const Row(
            children: [
              SizedBox(
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
            sharedPreferences.getString("type") != "manager"
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddRack(
                                pid: widget.pid,
                              )));
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: const Text(
                          "+ Rack",
                          style: TextStyle(color: Colors.grey),
                        )),
                  ),

            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Search()));
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  // ignore: prefer_const_constructors
                  child: Text(
                    "Search Box",
                    style: const TextStyle(color: Colors.grey),
                  )),
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () async {
                getHttp();
              },
            ),

            //
            // GestureDetector(
            //   onTap: (){
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(
            //         builder: (context) =>
            //             UploadRack(pid: widget.pid,)
            //     ));
            //   },
            //   child:  Container(
            //       padding: EdgeInsets.only(top: 20, right: 20),
            //       child: Text(
            //         "+ Upload Rack",
            //         style: TextStyle(color: Colors.grey),
            //       )) ,)
            // ,
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow[50],
          child: Container(
            child: Column(
              children: [
                productdetails == null
                    ? Container()
                    : productdetails.length == 0
                        ? Container()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 95,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: productdetails.length,
                                itemBuilder:
                                    (BuildContext context, int iindex) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: DefaultTextStyle(
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                  child: Text(
                                                    productdetails[iindex]["name"].toString(),
                                                  ))),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddSlab(
                                                            pid: productdetails[
                                                                iindex]["_id"],
                                                          )));
                                            },
                                            child: Container(
                                                child: const Text(
                                              " + Story",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8),
                                            )),
                                          )
                                        ],
                                      ),
                                      productdetails[iindex]["story"].length ==
                                              0
                                          ? Container()
                                          : Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  118,
                                              width: 100,
                                              margin: const EdgeInsets.all(5),
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ScrollPhysics(),
                                                  itemCount:
                                                      productdetails[iindex]
                                                              ["story"]
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SingleChildScrollView(
                                                        child: Column(
                                                            children: [
                                                          Container(
                                                              height: 80,
                                                              width: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border(
                                                                  top: const BorderSide(
                                                                      color: Colors
                                                                          .deepOrange,
                                                                      width: 5),
                                                                  bottom: index ==
                                                                          productdetails[iindex]["story"]
                                                                              .length
                                                                      ? const BorderSide(
                                                                          color: Colors
                                                                              .deepOrange,
                                                                          width:
                                                                              5)
                                                                      : const BorderSide(
                                                                          color: Colors
                                                                              .deepOrange,
                                                                          width:
                                                                              0),
                                                                  left: const BorderSide(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      width: 5),
                                                                  right: const BorderSide(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      width: 5),
                                                                ),
                                                              ),
                                                              child: productdetails[iindex]["story"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          'box'] ==
                                                                      0
                                                                  ? Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RackScreen(story: index.toString(), rack: productdetails[iindex]["name"].toString(), storyName: productdetails[iindex]["story"][index]["name"], sid: productdetails[iindex]["story"][index]["sid"].toString(), pid: productdetails[iindex]["_id"])));
                                                                          },
                                                                          child: Container(
                                                                              padding: const EdgeInsets.only(top: 20, right: 20),
                                                                              child: const Text(
                                                                                "+ Box",
                                                                                style: TextStyle(color: Colors.grey),
                                                                              )),
                                                                        ),
                                                                        Container()
                                                                      ],
                                                                    )
                                                                  : Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "  ${productdetails[iindex]["story"][index]['box']}",
                                                                              style: const TextStyle(color: Colors.green, fontSize: 11),
                                                                            ),
                                                                            Text(
                                                                              "/${productdetails[iindex]["story"][index]['cap']}",
                                                                              style: const TextStyle(color: Colors.red, fontSize: 11),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RackScreen(story: index.toString(), sid: productdetails[iindex]["story"][index]["sid"].toString(), storyName: productdetails[iindex]["story"][index]["name"].toString(), rack: productdetails[iindex]["name"].toString(), pid: productdetails[iindex]["_id"])));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: 50,
                                                                              margin: const EdgeInsets.only(top: 2),
                                                                              // margin: EdgeInsets.only(
                                                                              //     top: 2, left: 5, right: 5),
                                                                              decoration: const BoxDecoration(
                                                                                image: DecorationImage(
                                                                                  image: AssetImage('assets/box.png'),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                                color: Colors.transparent,
                                                                              ),

                                                                              // decoration: BoxDecoration(
                                                                              //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                                              //   borderRadius: BorderRadius.circular(1.0),
                                                                              // ),
                                                                              child: const SizedBox(
                                                                                  width: 150,
                                                                                  height: 30,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 150,
                                                                                        height: 30,
                                                                                        child: Column(
                                                                                          children: <Widget>[],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                            )),
                                                                      ],
                                                                    )
                                                              // ListView.builder(
                                                              //     scrollDirection: Axis.vertical,
                                                              //     shrinkWrap: true,
                                                              //     physics: ScrollPhysics(),
                                                              //     itemCount: productdetails[iindex]["story"][index]['box'],
                                                              //     itemBuilder:
                                                              //         (BuildContext context, int ndex) {
                                                              //
                                                              //       return
                                                              //         GestureDetector(
                                                              //             onTap: () async {
                                                              //               Navigator.of(context)
                                                              //                   .push(MaterialPageRoute(
                                                              //                   builder: (context) =>
                                                              //                       Files(pid: productdetails[iindex]["_id"], sid: productdetails[iindex]["story"][index]['sid'], box:  productdetails[iindex]["story"][index]['box'],)
                                                              //               ));
                                                              //             },
                                                              //             child:
                                                              //             Container(
                                                              //               height: 70,
                                                              //               margin: EdgeInsets.only(top: 2),
                                                              //               // margin: EdgeInsets.only(
                                                              //               //     top: 2, left: 5, right: 5),
                                                              //               decoration: BoxDecoration(
                                                              //                 image: DecorationImage(
                                                              //                   image: AssetImage(
                                                              //                       'assets/boxy.png'),
                                                              //                   fit: BoxFit.cover,
                                                              //                 ),
                                                              //
                                                              //                 color: Colors.transparent,
                                                              //
                                                              //               ),
                                                              //
                                                              //               // decoration: BoxDecoration(
                                                              //               //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                              //               //   borderRadius: BorderRadius.circular(1.0),
                                                              //               // ),
                                                              //               child:   Container(
                                                              //                   width: 150,
                                                              //                   height: 30,
                                                              //
                                                              //                   child: Column(
                                                              //                     children: [
                                                              //                       Container(
                                                              //                         width: 150,
                                                              //                         height: 30,
                                                              //                         child: Column(
                                                              //                           children: <Widget>[
                                                              //
                                                              //
                                                              //                           ],
                                                              //                         ),
                                                              //                       ),
                                                              //                     ],
                                                              //                   )),
                                                              //             ));
                                                              //     })

                                                              )
                                                        ]));
                                                  }),
                                            )
                                    ],
                                  );
                                }),
                          ),
              ],
            ),
          ),
        ),
      );
}
