// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/matchedScreens/matchedSuccessful.dart';
import 'package:crave/model/userModel.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/confirm_dialouge.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/custom_toast.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int next = 0;
  String matchedImageUrl = "";
  bool loading = false;
  bool matched = false;
  String searching = "Tap at the center to match";
  String finding = "We’re finding a great match for you!";
  int counter = 2;
  List<dynamic> allUserCraves = [];
  List<UsersModel> allUsersData = [];
  List<UsersModel> currentUsersData = [];
  List<UsersModel> CompleteUserData = [];
  List<UsersModel> matchedGenes = [];
  List<UsersModel> heteroCheck = [];
  List<dynamic> matchedCraves = [];
  bool isLoad = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();
  UsersModel? loggedInUser;
  UsersModel? allUsers;
  String? uid;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;

    currentuser();
    getAllUserData();
    checkforCounter();
  }

  checkforCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime date = DateTime(now.year, now.month, now.day);
    if (preferences.containsKey("counter")) {
      var countercheck = preferences.getBool("counter");
      print(countercheck);
      await firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("matching_Attempt")
          .doc(date.toString())
          .get()
          .then((value) {
        if (mounted) {
          log(counter.toString());
          setState(() {
            counter = value.data()!["counter"];

            isLoad = false;
          });
        } else {}
      }).catchError((e) {
        log(e.toString());
        setState(() {
          isLoad = false;
        });
      });
    } else {
      createcounterDb();
    }
  }

  createcounterDb() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("counter", false);
    DateTime date = DateTime(now.year, now.month, now.day);
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("matching_Attempt")
        .doc(date.toString())
        .set({'date': date.toString(), 'counter': 0}).then((text) {
      setState(() {
        isLoad = false;
        counter = 2;
      });
    }).catchError((e) {});
  }

  String image = "";
  currentuser() async {
    //currentuserdata

    await firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      loggedInUser = UsersModel.fromDocument(value);
      currentUsersData.add(loggedInUser!);

      if (mounted) {
        setState(() {
          image = currentUsersData[0].imgUrl[0].toString();
        });
      }
    });
  }

  getAllUserData() async {
    await firebaseFirestore
        .collection('users')
        .where("uid", isNotEqualTo: uid)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        //allUsersData.add(value.docs[i]);
        allUsers = UsersModel.fromDocument(value.docs[i]);
        allUsersData.add(allUsers!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Random Matches",
                    style: TextStyle(
                        fontFamily: 'Poppins-Medium', fontSize: 22.sp)),
                Stack(children: [
                  Image.asset(
                    circle,
                    width: 35.w,
                    height: 35.h,
                  ),
                  Positioned(
                    left: 12,
                    top: 5.7,
                    child: Text("$counter",
                        style: TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontSize: 14.sp,
                            color: const Color(0xff7A008F))),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
      body: ProgressHUD(
        inAsyncCall: isLoad,
        opacity: 0.1,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(matchframe), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Image.asset(
                  logo,
                  color: AppColors.redcolor,
                  width: 74.w,
                  //  height: 121.h,
                ),
                SizedBox(height: 10.h),
                //  const Spacer(flex: 1),
                text(context, searching, 19.sp,
                    color: Colors.white,
                    boldText: FontWeight.w200,
                    fontFamily: "Poppins-Regular"),
                const Spacer(flex: 1),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        match2,
                        width: 100.w,
                        height: 145.h,
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 25,
                      child: SizedBox(
                        width: 50.w,
                        height: 50.h,
                        child: ClipOval(
                          child: Image.network(
                            image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) {
                              return Text(
                                'Oops!! An error occurred. 😢',
                                style: TextStyle(fontSize: 16.sp),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const Spacer(flex: 1),
                InkWell(
                  onTap: () {
                    if (currentUsersData[0].gender == "Man") {
                      if (counter == 0) {
                        //dialogbox
                        const _paymentItems = [
                          PaymentItem(
                            label: 'Crave MatchPay',
                            amount: '1.99',
                            status: PaymentItemStatus.final_price,
                          )
                        ];
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  width: 515.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          width: 515.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.redcolor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(14.r),
                                                topRight:
                                                    Radius.circular(14.r)),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Action Required",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontSize: 22.sp),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: 50.w,
                                                height: 50.h,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.redcolor,
                                                ),
                                                child: Image.asset(icon)),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontSize: 20.sp),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "For further matching\npay 1.99 \$",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontSize: 18.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ApplePayButton(
                                              width: 200,
                                              height: 50,
                                              paymentConfigurationAsset:
                                                  'files/applepay.json',
                                              paymentItems: _paymentItems,
                                              style: ApplePayButtonStyle.black,
                                              type: ApplePayButtonType.buy,
                                              margin: const EdgeInsets.only(
                                                  top: 15.0),
                                              onPaymentResult: (data) {
                                                print(data);
                                              },
                                              loadingIndicator: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            GooglePayButton(
                                              width: 200,
                                              height: 50,
                                              paymentConfigurationAsset:
                                                  'files/gpay.json',
                                              paymentItems: _paymentItems,
                                              style: GooglePayButtonStyle.black,
                                              type: GooglePayButtonType.pay,
                                              margin: const EdgeInsets.only(
                                                  top: 15.0),
                                              onPaymentResult: (data) {
                                                print(data);
                                              },
                                              loadingIndicator: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        if (mounted) {
                          setState(() {
                            loading = true;
                          });
                        }
                        matchedGenes1();
                      }
                    } else {
                      matchedGenes1();
                    }
                  },
                  child: Container(
                    height: 89.w,
                    width: 89.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: loading
                        ? Image.asset(
                            "assets/raw/loadingmatch.gif",
                            height: 100,
                            width: 100,
                          )
                        : Image.asset(
                            i2,
                          ),
                  ),
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        match2,
                        width: 100.w,
                        height: 145.h,
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 208,
                      child: SizedBox(
                        width: 50.w,
                        height: 50.h,
                        child: ClipOval(
                            child: Image.network(
                          matchedImageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (
                            BuildContext context,
                            Object exception,
                            StackTrace? stackTrace,
                          ) {
                            return Text(
                              'Oops!! An error occurred. 😢',
                              style: TextStyle(fontSize: 16.sp),
                            );
                          },
                        )),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(finding,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontFamily: "Poppins-Regular",
                          fontWeight: FontWeight.w200,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//matched genes
  matchedGenes1() {
    CompleteUserData.clear();
    for (int i = 0; i < allUsersData.length; i++) {
      if (currentUsersData[0].genes == allUsersData[i].genes) {
        matchedGenes.add(allUsersData[i]);
      }
    }
    log(matchedGenes.length.toString());
    if (matchedGenes.length == 0) {
      ToastUtils.showCustomToast(context, "No Match Found", AppColors.redcolor);
    } else {
      //if hetero
      if (currentUsersData[0].genes == "Hetero") {
        matchedgenderifhetero();
      }
      //otherwise
      else {
        matchedCraves1();
      }
    }
  }

//if hetero
  matchedgenderifhetero() {
    for (int i = 0; i < matchedGenes.length; i++) {
      if (currentUsersData[0].gender != matchedGenes[i].gender) {
        heteroCheck.add(matchedGenes[i]);
      }
    }

    heteroOppositeGender();
  }

  heteroOppositeGender() async {
    int temp = 0;
    for (int i = 0; i < heteroCheck.length; i++) {
      var expectedList = currentUsersData[0]
          .craves
          .toSet()
          .intersection(heteroCheck[i].craves.toSet())
          .toList();
      if (heteroCheck.isEmpty) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        ToastUtils.showCustomToast(
            context, "No Match Found", AppColors.redcolor);
      } else {
        if (temp < expectedList.length) {
          CompleteUserData.add(heteroCheck[i]);
          temp = expectedList.length;
        }
      }
    }
    log("$next.toString()");
    log(CompleteUserData.length.toString());
    if (CompleteUserData.length == next) {
      ToastUtils.showCustomToast(
          context, "No Match Found, Try Agian", AppColors.redcolor);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      bool checkData = await matchedCheck(CompleteUserData[next].userId);
      log(checkData.toString());
      if (checkData == false) {
        addToFirebase();
      } else if (checkData == true) {
        if (mounted) {
          setState(() {
            increment();
          });
        }
        log(next.toString());
        matchedGenes1();
      }
    }
  }

//otherwise
  matchedCraves1() async {
    int temp = 0;
    for (int i = 0; i < allUsersData.length; i++) {
      var expectedList = currentUsersData[0]
          .craves
          .toSet()
          .intersection(allUsersData[i].craves.toSet())
          .toList();
      if (allUsersData.isEmpty) {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        ToastUtils.showCustomToast(
            context, "No Match Found", AppColors.redcolor);
      } else {
        if (temp < expectedList.length) {
          CompleteUserData.add(allUsersData[i]);
          temp = expectedList.length;
        }
      }
    }

    if (CompleteUserData.length == next) {
      ToastUtils.showCustomToast(
          context, "No Match Found, Try Agian", AppColors.redcolor);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      bool checkData = await matchedCheck(CompleteUserData[next].userId);
      log(checkData.toString());
      if (checkData == false) {
        addToFirebase();
      } else if (checkData == true) {
        if (mounted) {
          setState(() {
            increment();
          });
        }
        log(next.toString());
        matchedGenes1();
      }
    }
  }

  addToFirebase() async {
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("matches")
        .doc(CompleteUserData[next].userId)
        .set({
      'name': CompleteUserData[next].userName,
      'matchedId': CompleteUserData[next].userId,
      'imageUrl': CompleteUserData[next].imgUrl
    }).then((text) {
      Timer(const Duration(seconds: 2), () => getPicture());
    }).catchError((e) {});
  }

  decrement() {
    setState(() {
      counter = counter - 1;
    });
  }

  increment() {
    setState(() {
      next = next + 1;
    });
  }

  getPicture() {
    setState(() {
      matchedImageUrl = CompleteUserData[next].imgUrl[0];
      matched = true;
      loading = false;
      searching = "Matched Successful";
      finding = "Matched for You";
    });
    ToastUtils.showCustomToast(context, "MATCH FOUND", Colors.green);

    decrement();
    Timer(const Duration(seconds: 2), () async {
      final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MatchedSuccessed(
                    counter: counter,
                    imagurl: image,
                    img2url: matchedImageUrl,
                    participantid: uid!,
                    matchedid: CompleteUserData[next].userId,
                    participantname: currentUsersData[next].userName,
                    matchedname: CompleteUserData[next].userName,
                    showName: CompleteUserData[next].showName,
                  )));

      setState(() {
        if (refresh == "Refresh") {
          //getData();
          currentuser();
          getAllUserData();
          checkforCounter();
          next = next + 1;
          searching = "Tap at the center to match";
          finding = "We’re finding a great match for you!";
          matchedImageUrl = "";
        }
      });
    });

    print(matched);
  }

  Future<bool> matchedCheck(String uid) async {
    CollectionReference collectionReference = firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("matches");
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(uid).get();
    return documentSnapshot.exists;
  }
}
