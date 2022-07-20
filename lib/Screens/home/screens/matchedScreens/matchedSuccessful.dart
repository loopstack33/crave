// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchedSuccessed extends StatefulWidget {
  String imagurl,
      img2url,
      participantid,
      matchedid,
      participantname,
      matchedname;
  int counter;
  MatchedSuccessed(
      {Key? key,
      required this.imagurl,
      required this.img2url,
      required this.matchedid,
      required this.participantid,
      required this.matchedname,
      required this.counter,
      required this.participantname})
      : super(key: key);

  @override
  State<MatchedSuccessed> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchedSuccessed> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();
  String? uid;
  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    addCountertodb();
  }

  addCountertodb() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("key", true);
    DateTime date = DateTime(now.year, now.month, now.day);
    await firebaseFirestore
        .collection("users")
        .doc(uid)
        .collection("matching_Attempt")
        .doc(date.toString())
        .update({"counter": widget.counter})
        .then((text) {})
        .catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        //automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Random Matches",
                    style: TextStyle(
                        fontFamily: 'Poppins-Medium', fontSize: 22.sp)),
                Image.asset(
                  circle,
                  width: 30.w,
                  height: 30.h,
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xff191919),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            text(context, "YOU MATCHED!", 28.sp,
                color: Colors.white.withOpacity(0.58),
                fontFamily: "Poppins-Bold"),
            const Spacer(flex: 1),
            Stack(
              children: [
                Image.asset("assets/raw/stars.gif"),
                // Lottie.asset(stars),
                Positioned(
                  top: 35,
                  left: 40,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: RotationTransition(
                        turns: new AlwaysStoppedAnimation(-15 / 360),
                        child: Container(
                          width: 150.w,
                          height: 190.h,
                          padding: EdgeInsets.all(8), // Border width
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5,
                                  color: Color.fromARGB(255, 103, 102, 102)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),

                            // Image radius
                            child: Image.network(
                              widget.imagurl,
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
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                      )),
                ),

                Positioned(
                  top: 165,
                  left: 75,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(-15 / 360),
                    child: text(context, widget.participantname, 20.sp,
                        color: Colors.white, fontFamily: "Poppins-Medium"),
                  ),
                ),

                Positioned(
                  top: 70,
                  left: 180,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: RotationTransition(
                        turns: new AlwaysStoppedAnimation(15 / 360),
                        child: Container(
                          width: 150.w,
                          height: 190.h,
                          padding: EdgeInsets.all(8), // Border width
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 5,
                                  color: Color.fromARGB(255, 103, 102, 102)),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),

                            // Image radius
                            child: Image.network(
                              widget.img2url,
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
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
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
                      )),
                ),
                Positioned(
                  top: 200,
                  left: 185,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(15 / 360),
                    child: text(context, widget.matchedname, 20.sp,
                        color: Colors.white, fontFamily: "Poppins-Medium"),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            DefaultButton(text: "START CHAT", press: () {}),
            SizedBox(
              height: 20.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context, 'Refresh');
              },
              child: text(context, "I want another match", 18.sp,
                  color: Colors.white,
                  boldText: FontWeight.w500,
                  fontFamily: "Poppins-Medium"),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
