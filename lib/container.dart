import 'dart:convert';
import 'dart:ui';
import 'package:estore/addcity.dart';
import 'package:estore/addcontainer.dart';
import 'package:estore/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:estore/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:estore/auth/login.dart';

class ContainerScreeen extends StatefulWidget {
  final String pid;

  const ContainerScreeen({
    Key? key,
    required this.pid,
  });

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<ContainerScreeen> {
  late SharedPreferences sharedPreferences;

  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/container/getid?id=' + widget.pid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
        backgroundColor: Colors.blue[100],
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
          sharedPreferences.getString("type") != "manager"
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddContainer(
                              pid: widget.pid,
                            )));
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 20, right: 20),
                      child: Text(
                        "+ Warehouse",
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () async {
              getHttp();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/cargo.png'),
              fit: BoxFit.contain,
            ),
            color: Colors.blue[100],
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cargo.png'),
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
                            "Warehouse  ",
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  productdetails == null
                      ? Container()
                      : productdetails.length == 0
                          ? Container()
                          : Container(
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
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                        ),
                                        physics: ScrollPhysics(),
                                        itemCount: productdetails.length,
                                        itemBuilder:
                                            (BuildContext context, int iindex) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PackageScreen(
                                                            pid: productdetails[
                                                                iindex]["_id"],
                                                          )));
                                            },
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.only(
                                                  top: 2, left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                color: Color((math.Random()
                                                                .nextDouble() *
                                                            0xFFFFFF)
                                                        .toInt())
                                                    .withOpacity(1.0),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Container(
                                                  width: 150,
                                                  height: 50,
                                                  padding:
                                                      EdgeInsets.only(top: 0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 150,
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                                height: 60,
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      "assets/cargo.png"),
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(top: 3),
                                                              child:
                                                                  DefaultTextStyle(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white),
                                                                      child:
                                                                          Text(
                                                                        "${productdetails[iindex]["name"]}",
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
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ))),
                ],
              ),
            ),
          ]),
        ),
      ));

  Future<void> _showMyDialog(String data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 40,
              child: Image(
                image: AssetImage("assets/martlogo.png"),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(data),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
