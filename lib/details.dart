import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final String pid;

  const DetailScreen({
    Key? key,
    required this.pid,
  }) : super(key: key);

  static String routeName = "/splash";

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool hidepass = true;
  bool hideconpass = true;
  bool isChecked = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmpassController = new TextEditingController();

  TextEditingController couponController = new TextEditingController();

  bool _isLoading = false;
  var errorMsg;
  var productdetails;

  Future getAddress() async {
    http.Response presponse;
    print("fd " + widget.pid);
    presponse = await http.get(
      Uri.parse('https://susaqrapi.herokuapp.com/api/products/details?id=' +
          widget.pid),
    );
    setState(() {
      productdetails = json.decode(presponse.body);
    });
    print(productdetails);

    if (productdetails != null) {
      setState(() {
        nameController.text = productdetails["name"];
        phoneController.text = productdetails["des"];
        emailController.text = productdetails["price"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Center(
                  child: Row(
                children: [
                  Container(child: Text("Product details")),
                ],
              )),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              Container(
                  height: 200,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(),
                  child: Text("${widget.pid}")),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.green, Colors.green],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500]!,
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          var jsonResponse = null;
                          jsonResponse = json.decode(widget.pid.toString());
                          print(jsonResponse['id']);

                          String pid = jsonResponse['id'];

                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String id = sharedPreferences.getString('uid')!;
                          Map data = {"peid": id};

                          var url = Uri.parse(
                              "https://valid-octagon-370504.el.r.appspot.com/api/products/update?id=" +
                                  pid);
                          var response = await http.post(url, body: data);

                          if (response.statusCode == 200) {
                            jsonResponse = json.decode(response.body);
                            print(jsonResponse);
                            if (jsonResponse != null) {
                              setState(() {
                                _isLoading = false;
                              });
                              Fluttertoast.showToast(
                                msg: "Product Exit",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });

                            errorMsg = response.body;
                            Fluttertoast.showToast(
                              msg: "${json.decode(response.body)['msg']}",
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            print("The error message is: ${response.body}");
                          }
                        },
                        child: Center(
                          child: Text(
                            "Exit Product",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: 100,
              )),
            ],
          ),
          //   ),
          // ),
          // ],
          // ),
          //  ),
        ),
      ),
    );
  }
}
