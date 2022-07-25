// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/splash/welcome_screen.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> handleSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("logStatus", "null");
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Welcome_Screen()),
      (Route<dynamic> route) => false,
    );
    ToastUtils.showCustomToast(context, "Logout Successfully", Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.redcolor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.white,
        title: text(context, "Settings", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "Notifications", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "FAQ & Help", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "Community Guidelines", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
              onTap: () {
                handleSignOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  text(context, "Log Out", 18.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Poppins-Medium"),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            const Spacer(flex: 1),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        elevation: 10,
                        backgroundColor: AppColors.white,
                        child: SingleChildScrollView(
                          child: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setter) {
                              return Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.r),
                                          topRight: Radius.circular(20.r)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.redcolor.withOpacity(0.35),
                                          AppColors.redcolor
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Block User",
                                          style: TextStyle(
                                              fontSize: 22.sp,
                                              color: AppColors.white,
                                              fontFamily: 'Poppins-Regular',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Are you sure you want to delete your\nAccount forever?",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppColors.black,
                                              fontFamily: 'Poppins-Regular',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //here
                                          deleteForever();
                                        },
                                        child: Container(
                                          width: 150.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.redcolor
                                                    .withOpacity(0.35),
                                                AppColors.redcolor
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Yes",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins')),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 150.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppColors.redcolor
                                                    .withOpacity(0.35),
                                                AppColors.redcolor
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("No",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins')),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    });
              },
              child: text(context, "Delete Account", 22.sp,
                  color: AppColors.redcolor,
                  boldText: FontWeight.w500,
                  fontFamily: "Poppins-Medium"),
            ),
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              settingbottom,
              width: 108.w,
              height: 18.h,
            ),
          ],
        ),
      ),
    );
  }

  deleteForever() async {
    log("before");
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    QuerySnapshot messages = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "idFrom",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();

    if (messages.docs.isNotEmpty) {
      for (int i = 0; i < messages.docs.length; i++) {
        messages.docs[i].reference.delete();
      }
      log("deleted");
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "idFrom",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
    if (snapshot.docs.isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        snapshot.docs[i].reference.delete();
      }
      log("deleted");
    }

    QuerySnapshot snapshotchatto = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "idTo",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
    if (snapshotchatto.docs.isNotEmpty) {
      for (int i = 0; i < snapshotchatto.docs.length; i++) {
        snapshotchatto.docs[i].reference.delete();
      }
      log("deleted");
    }
    QuerySnapshot snapshotchatreportto = await FirebaseFirestore.instance
        .collection("reports")
        .where(
          "reportedId",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
    if (snapshotchatreportto.docs.isNotEmpty) {
      for (int i = 0; i < snapshotchatreportto.docs.length; i++) {
        snapshotchatreportto.docs[i].reference.delete();
      }
      log("deleted");
    }
    QuerySnapshot snapshotchatreportby = await FirebaseFirestore.instance
        .collection("reports")
        .where(
          "reportedBy",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
    if (snapshotchatreportby.docs.isNotEmpty) {
      for (int i = 0; i < snapshotchatreportby.docs.length; i++) {
        snapshotchatreportby.docs[i].reference.delete();
      }
      log("deleted");
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .delete();

    AppRoutes.pushAndRemoveUntil(
        context, PageTransitionType.fade, Welcome_Screen());
  }
}
