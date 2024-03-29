// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/homeScreen.dart';
import 'package:crave/Screens/splash/welcome_screen.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    //clearPref();
    Future.delayed(const Duration(seconds: 3), () => checkSignedIn());
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  checkSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getString("logStatus");
    if (status.toString() == "null") {
      AppRoutes.pushAndRemoveUntil(
          context, PageTransitionType.topToBottom, const Welcome_Screen());
    } else if (status.toString() != "null" && status.toString() == "true") {
      updateDeviceToken(FirebaseAuth.instance.currentUser!.uid, 'users');
      AppRoutes.pushAndRemoveUntil(
          context, PageTransitionType.topToBottom, const HomeScreen());
    } else {
      AppRoutes.pushAndRemoveUntil(
          context, PageTransitionType.topToBottom, const Welcome_Screen());
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  updateDeviceToken(id, collection) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var deviceT = await _firebaseMessaging.getToken();
    log(' deviceToken: $deviceT');
    await firebaseFirestore.collection(collection).doc(id).update({
      'deviceToken': deviceT,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.redcolor,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logo,
                width: 100,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
