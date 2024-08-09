import 'dart:convert';
import 'dart:ui';
import 'package:estore/QRView.dart';
import 'package:estore/addslab.dart';
import 'package:estore/constants.dart';
import 'package:estore/scanin.dart';
import 'package:estore/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RackScreen extends StatefulWidget {
  final String pid;
  final String? rack;
  final String? story;
  final String sid;
  final String? storyName;

  const RackScreen({
    Key? key,
    this.rack,
    this.storyName,
    this.story,
    required this.sid,
    required this.pid,
  }) : super(key: key);

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<RackScreen> {
  late SharedPreferences sharedPreferences;
  var productdetails;
  var storedetails;
  var boxdetails;
  Map<String, dynamic> mountedData = {};

  String removePrefix(String a, String b) {
    if (a.startsWith(b)) {
      return a.substring(b.length);
    }
    return a;
  }

  String removeString(String name, String storyName) {
    String result = name.replaceAll(storyName, '');
    print("string $result");
    return result;
  }

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    print("pid : ${widget.pid}");
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse(
            '$BASE_URL_LOC/rack/single-details?id=${widget.pid}&sid=${widget.sid}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    setState(() {
      productdetails = json.decode(sresponse.body);
    });
    print("productdetails : $productdetails");
  }

  Future getStory() async {
    //(id)
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    print("inside rack id : $id & sid : ${widget.sid}");
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse('$BASE_URL_LOC/store/getid-sid?id=$id&sid=${widget.sid}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    setState(() {
      storedetails = json.decode(sresponse.body);
    });
    print("storedetails $storedetails");
  }

  Future getBox() async {
    //id
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse =
        await (http.get(Uri.parse('${BASE_URL}api/box/getid?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      boxdetails = json.decode(sresponse.body);
    });
  }

  Map<String, dynamic> separateLettersAndNumbers(String input) {
    String alphabets = input.replaceAll(RegExp(r'\d'), '');
    String numbers = input.replaceAll(RegExp(r'[A-Za-z]'), '');

    return {'alphabets': alphabets, 'numbers': numbers};
  }

  Future getMountedData(sid) async {
    //id
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    print("get single sidd $sid");
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse(
            '$BASE_URL_LOC/box/get-specific?sid=$sid&story=${removeString(widget.storyName!, widget.rack!)}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    print("aaaa : ${jsonDecode(sresponse.body)}");

    setState(() {
      Map<String, dynamic> map = json.decode(sresponse.body);
      mountedData = {...mountedData, ...map};
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
    print("hiii ${widget.sid}");
    getMountedData(widget.sid);
    getStory();
    getBox();
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
  Widget build(BuildContext context) {
    // getHttp();
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.yellow[50],
        elevation: 0,
        titleSpacing: 0,
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
                        builder: (context) => AddSlab(
                              pid: widget.pid,
                            )));
                  },
                  child: Container(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: const Text(
                        "+ Story",
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
                child: const Text(
                  "Search",
                  style: TextStyle(color: Colors.grey),
                )),
          )
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
                  : productdetails["story"].length == 0
                      ? Container()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 95,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: productdetails["story"].length,
                              itemBuilder: (BuildContext context, int iindex) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: DefaultTextStyle(
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                child: Text(
                                                  productdetails["story"]
                                                          [iindex]["name"]
                                                      .toString(),
                                                ))),
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     Navigator.of(context)
                                        //         .push(MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             AddSlab(pid:productdetails[iindex]["_id"] ,)
                                        //     ));
                                        //   },
                                        //   child:  Container(
                                        //
                                        //       child: Text(
                                        //         " + Story",
                                        //         style: TextStyle(color: Colors.grey  , fontSize: 8),
                                        //       )) ,)
                                      ],
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              118,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: const BorderSide(
                                              color: Colors.deepOrange,
                                              width: 5),
                                          bottom: iindex ==
                                                  productdetails["story"]
                                                      [iindex]["box"]
                                              ? const BorderSide(
                                                  color: Colors.deepOrange,
                                                  width: 5)
                                              : const BorderSide(
                                                  color: Colors.deepOrange,
                                                  width: 0),
                                          left: const BorderSide(
                                              color: Colors.blueAccent,
                                              width: 5),
                                          right: const BorderSide(
                                              color: Colors.blueAccent,
                                              width: 5),
                                        ),
                                      ),
                                      margin: const EdgeInsets.all(5),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                          ),
                                          physics: const ScrollPhysics(),
                                          itemCount: productdetails["story"]
                                              [iindex]["cap"],
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                                onTap: () async {
                                                  if (sharedPreferences
                                                          .getString("type") ==
                                                      "manager") {
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .landscapeRight,
                                                      DeviceOrientation
                                                          .landscapeLeft,
                                                      DeviceOrientation
                                                          .portraitUp,
                                                      DeviceOrientation
                                                          .portraitDown,
                                                    ]);

                                                    print(
                                                        "data : ${widget.pid} ${productdetails["story"][iindex]["sid"]} ${productdetails["story"][iindex]["box"]} name : ${productdetails["story"][iindex]["name"]} id : ${productdetails['_id']}");

                                                    // productdetails["story"]
                                                    //                     [iindex]
                                                    //                 ["box"] -
                                                    //             1 >=
                                                    //         index
                                                    mountedData[productdetails["story"]
                                                                        [iindex]
                                                                    ["sid"]] !=
                                                                [] &&
                                                            // mountedData["X198"]
                                                            //     .contains(iindex + 1)
                                                            // mountedData[productdetails["story"][iindex]["sid"]][iindex]
                                                            //         ["mount"] !=
                                                            //     null

                                                            mountedData[productdetails["story"][iindex]["sid"]]
                                                                    ["position"]
                                                                .contains((index + 1)
                                                                    .toString())
                                                        ? Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => ScanScreen(
                                                                position: index + 1,
                                                                pid: productdetails['_id'],
                                                                onsuccess: () {
                                                                  productdetails[
                                                                              "story"]
                                                                          [
                                                                          iindex]
                                                                      [
                                                                      "box"] = productdetails[
                                                                              "story"][iindex]
                                                                          [
                                                                          "box"] -
                                                                      1;
                                                                },
                                                                sid: productdetails["story"][iindex]["sid"],
                                                                box: productdetails["story"][iindex]["box"])))
                                                        : (productdetails["story"][iindex]["box"] < productdetails["story"][iindex]["cap"])
                                                            ? Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => ScanIn(
                                                                    position: index + 1,
                                                                    pid: productdetails['_id'],
                                                                    sid: productdetails["story"][iindex]["sid"],
                                                                    rname: productdetails["name"],
                                                                    box: productdetails["story"][iindex]["box"],
                                                                    onsuccess: () {
                                                                      productdetails["story"]
                                                                              [
                                                                              iindex]
                                                                          [
                                                                          "box"] = productdetails["story"][iindex]
                                                                              [
                                                                              "box"] +
                                                                          1;
                                                                    })))
                                                            : Fluttertoast.showToast(
                                                                msg:
                                                                    "Rack capacity is full",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                              );
                                                    getHttp();
                                                  }
                                                },
                                                child: Container(
                                                  height: 70,
                                                  margin: const EdgeInsets.only(
                                                      top: 2),
                                                  // margin: EdgeInsets.only(
                                                  //     top: 2, left: 5, right: 5),
                                                  decoration: mountedData[productdetails["story"]
                                                                      [iindex]
                                                                  ["sid"]] !=
                                                              null &&
                                                          mountedData[productdetails["story"][iindex]["sid"]][
                                                                      "position"]
                                                                  .length >
                                                              0 &&
                                                          // mountedData["X198"]
                                                          //     .contains(iindex + 1)
                                                          mountedData[productdetails["story"]
                                                                          [iindex]
                                                                      ["sid"]]
                                                                  ["position"]
                                                              .contains((index + 1)
                                                                  .toString())
                                                      //         &&
                                                      // mountedData[productdetails[
                                                      //                 "story"]
                                                      //             [iindex]["sid"]]
                                                      //         [iindex]["mount"] !=
                                                      //     null
                                                      // productdetails["story"][
                                                      //                     iindex]
                                                      //                 ["box"] -
                                                      //             1 >=
                                                      //         index
                                                      ? const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/box.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          color: Colors
                                                              .transparent,
                                                        )
                                                      : const BoxDecoration(
                                                          color: Colors.grey,
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
                                                ));
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
}
