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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../widgets/custom_toast.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool loading = false;
  int counter = 0;
  List<dynamic> allUserCraves = [];
  List<UsersModel> allUsersData = [];
  List<UsersModel> currentUsersData = [];
  List<UsersModel> CompleteUserData = [];
  List<UsersModel> matchedGenes = [];
  List<dynamic> matchedCraves = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UsersModel? loggedInUser;
  UsersModel? allUsers;
  String? uid;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
//currentuserdata
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      loggedInUser = UsersModel.fromDocument(value);
      currentUsersData.add(loggedInUser!);
      log(currentUsersData[0].imgUrl[0]);
    });

    getAllUserData();
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
      body: Container(
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
                    top: 9,
                    left: 18,
                    child: Container(
                      height: 70.w,
                      width: 65.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        currentUsersData[0].imgUrl[0],
                        fit: BoxFit.cover,
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
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  match22,
                  width: 100.w,
                  height: 145.h,
                ),
              ),
              const Spacer(flex: 1),
              InkWell(
                onTap: () {
                  AppRoutes.push(context, PageTransitionType.fade,
                      const MatchedSuccessed());
                },
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
      Timer(const Duration(seconds: 3), () {
        getPicture();
      });
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
      loading = false;
    });
    print("in picture");
  }
}
