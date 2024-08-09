import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:estore/constants.dart';
//import 'package:simple_animations/stateless_animation/mirror_animation.dart';

class Requests extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<Requests> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];
  int currentPage = 0;
  var aproductdetails;
  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http
        .get(Uri.parse('${BASE_URL}api/request/getid?id=' + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      productdetails = json.decode(presponse.body);
    });
    print(productdetails);
  }

  @override
  void initState() {
    super.initState();
    getHttp();
    _myPage = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[100],
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(3),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.all(5),
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "History",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: MediaQuery.of(context).size.height - 270,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Container(
                  child: Column(
                    children: [
                      productdetails == null
                          ? Container(
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/loadgif.gif"),
                                height: 100,
                                width: 100,
                              ))
                          : productdetails.length == 0
                              ? Container(
                                  child: Text(
                                    "Empty",
                                    style: TextStyle(color: Color(0xFF00b207)),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: productdetails.length,
                                  itemBuilder:
                                      (BuildContext context, int iindex) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                padding: EdgeInsets.all(5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 5),
                                                      blurRadius: 23,
                                                      spreadRadius: -13,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(width: 30),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Column(
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                      "Box ID : ${productdetails[iindex]["bid"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold))),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                      "Date ${productdetails[iindex]["time"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold))),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                      "Status ${productdetails[iindex]["status"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold))),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 40.0,
                                                  color: Color(0xFF00b207),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        onTap: () {
                                                          // Navigator.of(
                                                          //     context)
                                                          //     .push(
                                                          //     MaterialPageRoute(
                                                          //       builder:
                                                          //           (context) =>
                                                          //           Invoice(oid: "${aproductdetails[iindex]["_id"]}"),
                                                          //     ));
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
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
      );

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 40,
      width: MediaQuery.of(context).size.width / 2 - 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.pink : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: currentPage == index ? Text("Da") : Text("Ad"),
    );
  }
}
