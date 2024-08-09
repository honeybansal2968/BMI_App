import 'dart:convert';
import 'dart:ui';
import 'package:estore/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:estore/auth/login.dart';

class Managerscreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<Managerscreen> {
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
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  TextEditingController couponController = new TextEditingController();
  List cartsarray = [];
  List cartsqaun = [];
  int subtotal = 0;
  int total = 0;
  int discount = 0;
  String oproduct = "";
  List _ch = ["Delhi", "Haryana", "Mumbai"];
  int count = 1;
  var ch;
  int dcharge = 0;
  var enquiryValue = 'Day after tomorrow';
  static final DateTime now = DateTime.now();

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/streams/gettop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response bresponse;
    bresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/images/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response presponse;
    presponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/packages/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    http.Response caresponse;
    caresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/category/getcategories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    setState(() {
      productdetails = json.decode(presponse.body);
      bannerdetails = json.decode(bresponse.body);
      superdetails = json.decode(sresponse.body);
      catdetails = json.decode(caresponse.body);
    });
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
        backgroundColor: Colors.blue[100],
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(
              width: 30,
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
          Container(
              padding: EdgeInsets.only(top: 20, right: 20),
              child: Text(
                "+ Cities",
                style: TextStyle(color: Colors.grey),
              )),
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
              image: AssetImage('assets/city.png'),
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
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          child: Text(
                            "Cities  ",
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 270,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: 1,
                      itemBuilder: (context, index) => index == 0
                          ? SingleChildScrollView(
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
                                                          pid: "pid",
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
                                                          SizedBox(
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
                                                              child: Image(
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
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child:
                                                                DefaultTextStyle(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                    child: Text(
                                                                      "${_ch[iindex]}",
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
                            ))
                          : index == 1
                              ? SingleChildScrollView(
                                  child: Container(
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          physics: ScrollPhysics(),
                                          itemCount: productdetails.length,
                                          itemBuilder: (BuildContext context,
                                              int iindex) {
                                            return GestureDetector(
                                              onTap: () {
                                                // Navigator.of(context)
                                                //     .push(MaterialPageRoute(
                                                //   builder: (context) =>
                                                //       ProductDetails(
                                                //         index:
                                                //         "${productdetails[iindex]["h5page"]}",
                                                //         cate:
                                                //         "${productdetails[iindex]["pcat"]}",
                                                //       ),
                                                // ));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, top: 2),
                                                padding: EdgeInsets.all(5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${productdetails[iindex]["pphoto"]}"),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //       offset: Offset(0, 0),
                                                  //       blurRadius: 0.5,
                                                  //       spreadRadius: 0.5,
                                                  //       color: Colors.deepOrange
                                                  //   ),
                                                  // ],
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    // Image(
                                                    //   height: 110,
                                                    //   width: 125 ,
                                                    //   image:
                                                    //   NetworkImage("${productdetails[iindex]["pphoto"]}")
                                                    //   ,
                                                    //   fit: BoxFit.fill,
                                                    // ),
                                                    Container(
                                                        width: 200,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 0),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              width: 150,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child: Text(
                                                                          "${productdetails[iindex]["pname"]}",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.bold))),
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child: Text(
                                                                          "${productdetails[iindex]["pdes"]}",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 8))),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove_red_eye,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          )),
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        padding:
                                                                            EdgeInsets.only(top: 7),
                                                                        child: Text(
                                                                            " ${productdetails[iindex]["view"].toString()}",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 13,
                                                                                color: Colors.white)),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  //  Container(
                                                                  //    width:50,
                                                                  //    child:Column(
                                                                  //   children: [
                                                                  //     // Container( height: 50 ,margin : EdgeInsets.only(left: 0),child: IconButton(
                                                                  //     //     icon: const Icon(Icons.favorite_outline , color:  Color(0xFF00b207), size: 30,),
                                                                  //     //     onPressed: () async {
                                                                  //     //       sharedPreferences = await SharedPreferences.getInstance();
                                                                  //     //       String uid =  sharedPreferences.getString("uid");
                                                                  //     //       var url = Uri.parse("https://vakeemagro.el.r.appspot.com/api/wishlist/addtowishlist");
                                                                  //     //       var hresponse = await http.post(url,  headers: {
                                                                  //     //         "Content-Type": "application/json"
                                                                  //     //       }, body:
                                                                  //     //       json.encode(
                                                                  //     //           {
                                                                  //     //             'cid': uid,
                                                                  //     //             'pid': "${productdetails[iindex]["_id"]}",
                                                                  //     //           }));
                                                                  //     //       var jsonResponse = null;
                                                                  //     //       if(hresponse.statusCode == 200) {
                                                                  //     //
                                                                  //     //           Fluttertoast.showToast(
                                                                  //     //             msg: "Added to Wishlist",
                                                                  //     //             toastLength: Toast.LENGTH_SHORT,
                                                                  //     //           );
                                                                  //     //
                                                                  //     //       }
                                                                  //     //       else {
                                                                  //     //         var errorMsg = hresponse.body;
                                                                  //     //         Fluttertoast.showToast(
                                                                  //     //           msg: "${json.decode(hresponse.body)}",
                                                                  //     //           toastLength: Toast.LENGTH_SHORT,
                                                                  //     //         );
                                                                  //     //         print("The error message is: ${json.decode(hresponse.body)}");
                                                                  //     //       }
                                                                  //     //
                                                                  //     //
                                                                  //     //     }
                                                                  //     //
                                                                  //     // ) ,),
                                                                  //     // SizedBox(height: 10,),
                                                                  //     Container(
                                                                  //       height: 50,
                                                                  //
                                                                  //       child:
                                                                  //     Row(
                                                                  //       children: [
                                                                  //         Expanded(child: SizedBox(width: 5,)),
                                                                  //
                                                                  //         Container(
                                                                  //           height: 32,
                                                                  //
                                                                  //           decoration: BoxDecoration(
                                                                  //             color:  Color(0xFF00b207),
                                                                  //             borderRadius: BorderRadius.circular(5),
                                                                  //           ),
                                                                  //           width: 30,
                                                                  //
                                                                  //           child: IconButton(
                                                                  //             iconSize: 16,
                                                                  //             icon: const Icon(Icons.shopping_bag , color: Colors.white,),
                                                                  //             tooltip: 'Increase volume by 10',
                                                                  //             onPressed: () {
                                                                  //               List cartarray =  sharedPreferences.getStringList("cartarray");
                                                                  //               List cartqant =  sharedPreferences.getStringList("cartquantity");
                                                                  //               int _inx = 0;
                                                                  //               int pv =0;
                                                                  //               print(cartarray);
                                                                  //               cartarray!=null? {
                                                                  //                 if(cartarray.isEmpty){
                                                                  //                   sharedPreferences.setStringList("cartarray", ["${productdetails[iindex]["_id"]}"]),
                                                                  //                   sharedPreferences.setStringList("cartquantity", ["1"])
                                                                  //                 }else{
                                                                  //                   _inx   =  cartarray.indexOf("${productdetails[iindex]["_id"]}"),
                                                                  //                   if(_inx != -1){
                                                                  //
                                                                  //                   }else{
                                                                  //                     cartarray.add("${productdetails[iindex]["_id"]}"),
                                                                  //                     cartqant.add("1"),
                                                                  //                     sharedPreferences.setStringList("cartarray", cartarray),
                                                                  //                     sharedPreferences.setStringList("cartquantity", cartqant)
                                                                  //
                                                                  //                   },
                                                                  //
                                                                  //
                                                                  //
                                                                  //                 }
                                                                  //
                                                                  //
                                                                  //               }:{
                                                                  //                 sharedPreferences.setStringList("cartarray", ["${productdetails[iindex]["_id"]}"]),
                                                                  //                 sharedPreferences.setStringList("cartquantity", ["1"])
                                                                  //
                                                                  //
                                                                  //               };
                                                                  //               print(cartarray);
                                                                  //               print( sharedPreferences.getStringList("cartquantity"));
                                                                  //               // List cartsarray =  sharedPreferences.getStringList("cartarray");
                                                                  //
                                                                  //               Navigator.of(context).push(MaterialPageRoute(
                                                                  //                 builder: (context) => Cart(),
                                                                  //               ));
                                                                  //             },
                                                                  //
                                                                  //
                                                                  //           ),
                                                                  //         )
                                                                  //       ],
                                                                  //     ),),
                                                                  //
                                                                  //
                                                                  //
                                                                  //   ],
                                                                  // ) ,)
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ))
                              : index == 2
                                  ? SingleChildScrollView(
                                      child: Container(
                                      child: Column(
                                        children: [
                                          GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                              ),
                                              physics: ScrollPhysics(),
                                              itemCount: productdetails.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int iindex) {
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5, top: 5),
                                                    padding: EdgeInsets.all(5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "${productdetails[iindex]["pphoto"]}"),
                                                          fit: BoxFit.fill),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //       offset: Offset(0, 0),
                                                      //       blurRadius: 0.5,
                                                      //       spreadRadius: 0.5,
                                                      //       color: Colors.deepOrange
                                                      //   ),
                                                      // ],
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        // Image(
                                                        //   height: 110,
                                                        //   width: 125 ,
                                                        //   image:
                                                        //   NetworkImage("${productdetails[iindex]["pphoto"]}")
                                                        //   ,
                                                        //   fit: BoxFit.fill,
                                                        // ),
                                                        Container(
                                                            width: 200,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Column(
                                                                    children: <Widget>[
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .bottomLeft,
                                                                          child: Text(
                                                                              "${productdetails[iindex]["pname"]}",
                                                                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .bottomLeft,
                                                                          child: Text(
                                                                              "${productdetails[iindex]["pdes"]}",
                                                                              style: TextStyle(color: Colors.white, fontSize: 8))),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              height: 30,
                                                                              child: Icon(
                                                                                Icons.remove_red_eye,
                                                                                color: Colors.white,
                                                                                size: 20,
                                                                              )),
                                                                          Container(
                                                                            height:
                                                                                30,
                                                                            padding:
                                                                                EdgeInsets.only(top: 7),
                                                                            child:
                                                                                Text(" ${productdetails[iindex]["view"].toString()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ))
                                  : SingleChildScrollView(
                                      child: Container(
                                      child: Column(
                                        children: [
                                          Container(),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ));

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
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
