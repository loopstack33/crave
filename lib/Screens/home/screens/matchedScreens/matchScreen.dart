// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/matchedScreens/matchedSuccessful.dart';
import 'package:crave/model/userModel.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/confirm_dialouge.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/custom_toast.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  String matchedImageUrl = "";
  bool loading = false;
  bool matched = false;
  int counter = 0;
  List<dynamic> allUserCraves = [];
  List<UsersModel> allUsersData = [];
  List<UsersModel> currentUsersData = [];
  List<UsersModel> CompleteUserData = [];
  List<UsersModel> matchedGenes = [];
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
          setState(() {
            counter = value.data()!["counter"];

            isLoad = false;
          });
        }
      }).catchError((e) {
        log(e.toString());
      });
      // if (countercheck==false) {
      //   print("created before");
      //   await firebaseFirestore
      //       .collection("users")
      //       .doc(_auth.currentUser!.uid)
      //       .collection("matching_Attempt")
      //       .doc(date.toString())
      //       .get()
      //       .then((value) {
      //     if (mounted) {
      //       counter = value.data()!["counter"];
      //       print(counter);
      //       isLoad = false;
      //     }
      //   }).catchError((e) {
      //     log(e.toString());
      //   });
      // } else {
      //   if (mounted) {
      //     setState(() {
      //       isLoad = false;
      //     });
      //   }
      // }
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
        counter = 0;
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
                            color: Color(0xff7A008F))),
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
                text(context, "Searching...", 19.sp,
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
                    if (counter > 1) {
                      //dialogbox
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialog(
                                message:
                                    "For furthur matching you have to pay \$2",
                                press: () {});
                          });
                    } else {
                      // log(currentUsersData[0].genes.toString());
                      // log(allUsersData[1].genes.toString());
                      // log({currentUsersData[0].genes == allUsersData[1].genes}
                      //     .toString());
                      if (mounted) {
                        setState(() {
                          loading = true;
                        });
                      }
                      matchedGenes1();

                      // increment();
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
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("We’re finding a great match for you!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontFamily: "Poppins-Regular",
                            fontWeight: FontWeight.w200,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  matchedGenes1() {
    setState(() {
      loading = true;
    });
    for (int i = 0; i < allUsersData.length; i++) {
      if (currentUsersData[0].genes == allUsersData[i].genes) {
        matchedGenes.add(allUsersData[i]);
      }
    }
    log(matchedGenes[0].genes.toString());
    log(allUsersData[0].userName.toString());

    matchedCraves1();
  }

  matchedCraves1() {
    int temp = 0;
    for (int i = 0; i < allUsersData.length; i++) {
      var expectedList = currentUsersData[0]
          .craves
          .toSet()
          .intersection(allUsersData[i].craves.toSet())
          .toList();

      //  log(expectedList.length.toString());

      if (temp < expectedList.length) {
        CompleteUserData.add(allUsersData[i]);
        temp = expectedList.length;
        //   log(allUsersData[i].userId.toString());
      }
    }
    // log(matchedGenes[0].genes.toString());
    log(CompleteUserData[0].userName.toString());
    log(CompleteUserData[0].imgUrl.toString());
    addToFirebase();
    // matchedCraves.add(expectedList);
  }

  addToFirebase() async {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }

    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("matches")
        .doc(next.toInt().toString())
        .set({
      'name': CompleteUserData[0].userName,
      'matchedId': CompleteUserData[0].userId,
      'imageUrl': CompleteUserData[0].imgUrl
    }).then((text) {
      print("in");
      Timer(const Duration(seconds: 2), () => getPicture());
      // ToastUtils.showCustomToast(context, "MATCH FOUND", Colors.green);
      // if (mounted) {
      //   setState(() {
      //     loading = false;
      //   });
      // }
    }).catchError((e) {});
  }

  increment() {
    setState(() {
      counter = counter + 1;
    });
  }

  getPicture() {
    setState(() {
      matchedImageUrl = CompleteUserData[0].imgUrl[0];
      matched = true;
      loading = false;
    });
    ToastUtils.showCustomToast(context, "MATCH FOUND", Colors.green);
    increment();
    Timer(const Duration(seconds: 2), () async {
      final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MatchedSuccessed(
                    counter: counter,
                    imagurl: image,
                    img2url: matchedImageUrl,
                    participantid: uid!,
                    matchedid: CompleteUserData[0].userId,
                    participantname: currentUsersData[0].userName,
                    matchedname: CompleteUserData[0].userName,
                  )));

      setState(() {
        if (refresh == "Refresh") {
          //getData();
          currentuser();
          getAllUserData();
          checkforCounter();
        }
      });
    });
    print(matched);
  }
}
