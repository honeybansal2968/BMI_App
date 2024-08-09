import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:estore/constants.dart';

class RequestDetails extends StatefulWidget {
  final String pid;

  const RequestDetails({
    Key? key,
    required this.pid,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<RequestDetails> {
  bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  String dropdownValue = 'Client';
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  late SharedPreferences sharedPreferences;
  var productdetails;

  Future getHttp() async {
    print(widget.pid);

    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/box/details?id=' + widget.pid),
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
    // TODO: implement initState
    super.initState();
    getHttp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue[50],
          width: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              Container(
                color: Colors.blue[50],
                height: 60,
                child: Image(
                  image: AssetImage("assets/box.png"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 65,
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(),
                child: Text("Box IDs \n${{widget.pid}}"),
              ),
              Container(
                height: 65,
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                padding: EdgeInsets.all(8.0),
                child: Text("Box Details"),
              ),
              productdetails != null
                  ? Container(
                      margin: EdgeInsets.only(left: 8.0, right: 8.0),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Box No : ${productdetails['name']}\n Box Type : ${productdetails['type']} \nWarehouse No : ${productdetails['container']}\n Rack No : ${productdetails['rack']}\nStory No : ${productdetails['story']}\n Box Position : ${productdetails['position']} "),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  color: Colors.orange,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          String email = emailController.text.trim();
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var id = sharedPreferences.getString('uid');

                          Map data = {
                            'bid': widget.pid,
                            'sid': id,
                            'time': DateTime.now().toString(),
                            'status': ''
                          };

                          var jsonResponse = null;
                          var url = Uri.parse("${BASE_URL}api/request/add");
                          var response = await http.post(url, body: data);
                          if (response.statusCode == 200) {
                            jsonResponse = json.decode(response.body);
                            print(jsonResponse);
                            if (jsonResponse != null) {
                              Fluttertoast.showToast(
                                msg: "Request Send!",
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

                          // String name= emailController.text.trim();
                          //
                          // Map data = {
                          //   'name': name,
                          //   'aid' :'',
                          //   'cid' : widget.pid
                          //
                          // };
                          //
                          // print(data);
                          //
                          // var jsonResponse = null;
                          // var url = Uri.parse(
                          //     "${BASE_URL}api/box/add");
                          // var response = await http.post(url, body: data);
                          //
                          // if (response.statusCode == 200) {
                          //   jsonResponse = json.decode(response.body);
                          //   if (jsonResponse != null) {
                          //
                          //     Map bdata = {
                          //       'id': widget.pid,
                          //       'sid' : widget.pid,
                          //       'box' : widget.pid,
                          //
                          //     };
                          //     print(bdata);
                          //
                          //     var jsonResponse = null;
                          //     var url = Uri.parse(
                          //         "${BASE_URL}api/rack/updatestory");
                          //     var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(bdata));
                          //
                          //     if (response.statusCode == 200) {
                          //       jsonResponse = json.decode(response.body);
                          //       print(jsonResponse);
                          //       if (jsonResponse != null) {
                          //
                          //         Fluttertoast.showToast(
                          //           msg: "Box Unmounted!",
                          //           toastLength: Toast.LENGTH_SHORT,
                          //         );
                          //
                          //
                          //
                          //         // Navigator.of(context).pushAndRemoveUntil(
                          //         //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                          //         //     (Route<dynamic> route) => false);
                          //       }
                          //     } else {
                          //
                          //       Fluttertoast.showToast(
                          //         msg: "${json.decode(response.body)}",
                          //         toastLength: Toast.LENGTH_SHORT,
                          //       );
                          //       print("The error message is: ${response.body}");
                          //     }
                          //
                          //
                          //     // Navigator.of(context).pushAndRemoveUntil(
                          //     //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                          //     //     (Route<dynamic> route) => false);
                          //   }
                          // } else {
                          //
                          //   Fluttertoast.showToast(
                          //     msg: "${json.decode(response.body)}",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //   );
                          //   print("The error message is: ${response.body}");
                          // }
                        },
                        child: Center(
                          child: Text(
                            "Unmount Request",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
