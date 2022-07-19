// ignore_for_file: file_names

import 'dart:developer';

import 'package:crave/Screens/home/screens/matchedScreens/matchedSuccessful.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/confirm_dialouge.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int counter = 0;
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
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  match2,
                  width: 100.w,
                  height: 145.h,
                ),
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
                    increment();
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
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
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

  increment() {
    setState(() {
      counter = counter + 1;
    });
  }
}
