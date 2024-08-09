import 'dart:convert';
import 'dart:ui';
import 'package:estore/addcity.dart';
import 'package:estore/billing.dart';
import 'package:estore/container.dart';
import 'package:estore/home.dart';
import 'package:estore/requestlistt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estore/constants.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:estore/auth/login.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<ClientScreen> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];
  int currentPage = 0;
  int bcurrentPage = 0;
  var productdetails;
  var superdetails;
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  var bannerdetails;
  var catdetails;
  var stringResponse;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  List cartsarray = [];
  List cartsqaun = [];
  int subtotal = 0;
  int total = 0;
  int discount = 0;
  String oproduct = "";
  final List _ch = ["Delhi", "Haryana", "Mumbai"];
  int count = 1;
  var ch;
  int dcharge = 0;
  var enquiryValue = 'Day after tomorrow';
  static final DateTime now = DateTime.now();

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    print(sharedPreferences.getString("type"));

    http.Response caresponse;
    caresponse =
        await (http.get(Uri.parse('${BASE_URL}api/city/getall'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));
    print("response ${caresponse.body}");
    setState(() {
      productdetails = json.decode(caresponse.body);
    });
  }

  @override
  void initState() {
    super.initState();

    getHttp();
    _myPage = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          elevation: 0,
          titleSpacing: 0,
          title: const Row(
            children: [
              SizedBox(
                width: 30,
              ),
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
            sharedPreferences.getString("type") == "manager"
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddCity()));
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: const Text(
                          "+ Cities",
                          style: TextStyle(color: Colors.grey),
                        )),
                  )
                : Container(),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Billing()));
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: const Text(
                    "Bills",
                    style: TextStyle(color: Colors.grey),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Requests()));
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: const Text(
                    "Requests",
                    style: TextStyle(color: Colors.grey),
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
            IconButton(
              icon: const Icon(
                Icons.logout,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/city.png'),
                fit: BoxFit.contain,
              ),
              color: Colors.blue[100],
            ),
            width: double.infinity,
            child: Column(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 120,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/city.png'),
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
                    const SizedBox(height: 10),
                    const Align(
                        alignment: Alignment.center,
                        child: DefaultTextStyle(
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            child: Text(
                              "Cities  ",
                            ))),
                    const SizedBox(
                      height: 10,
                    ),
                    productdetails.length == 0
                        ? Container()
                        : SizedBox(
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
                                      physics: const ScrollPhysics(),
                                      itemCount: productdetails.length,
                                      itemBuilder:
                                          (BuildContext context, int iindex) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ContainerScreeen(
                                                          pid: productdetails[
                                                              iindex]["_id"],
                                                        )));
                                          },
                                          child: Container(
                                            height: 50,
                                            margin: const EdgeInsets.only(
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
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        children: <Widget>[
                                                          // Align(
                                                          //   alignment:
                                                          //   Alignment.topRight,
                                                          //   child:Container(
                                                          //       padding: EdgeInsets.all(4),
                                                          //       decoration: BoxDecoration(
                                                          //         gradient: LinearGradient(
                                                          //           colors: [
                                                          //             Colors.orange[300],
                                                          //             Colors.pink[300],
                                                          //           ],
                                                          //         ),
                                                          //         borderRadius: BorderRadius.circular(15),
                                                          //       ),
                                                          //       child:
                                                          //       DefaultTextStyle(
                                                          //           style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                                          //           child:
                                                          //           Text(
                                                          //             "Limited Offer",
                                                          //           )))
                                                          //   ,),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          // Row(children: [
                                                          //   Align(
                                                          //       alignment:
                                                          //       Alignment.center,
                                                          //       child:DefaultTextStyle(
                                                          //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                          //           child:
                                                          //           Text(
                                                          //             "      ",
                                                          //           ))),
                                                          //   Align(
                                                          //       alignment:
                                                          //       Alignment.center,
                                                          //       child:Icon(Icons.diamond_outlined  , color: Colors.blue,)),
                                                          //   Align(
                                                          //       alignment:
                                                          //       Alignment.center,
                                                          //       child:DefaultTextStyle(
                                                          //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                                          //           child:
                                                          //           Text(
                                                          //             "${productdetails[iindex]["coins"]}   ",
                                                          //           ))
                                                          //
                                                          //   ),
                                                          // ],) ,
                                                          Container(
                                                              child:
                                                                  const Image(
                                                            image: AssetImage(
                                                                "assets/city.png"),
                                                          )),

                                                          // Container(
                                                          //   padding: EdgeInsets.only(
                                                          //       top: 3),
                                                          //   child:
                                                          //   DefaultTextStyle(
                                                          //       style: TextStyle(fontSize: 12,
                                                          //           color: Colors.grey,
                                                          //           decoration:
                                                          //           TextDecoration
                                                          //               .lineThrough,
                                                          //           fontWeight: FontWeight.bold),
                                                          //       child:
                                                          //       Text(
                                                          //         "",
                                                          //       )),
                                                          //
                                                          // ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3),
                                                            child:
                                                                DefaultTextStyle(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                    child: Text(
                                                                      "${productdetails[iindex]["name"]}",
                                                                    )),
                                                          ),
                                                          const SizedBox(
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
                                  const SizedBox(
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

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: bcurrentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: bcurrentPage == index ? Colors.pink[300] : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Future<void> _showMyDialog(String data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
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
