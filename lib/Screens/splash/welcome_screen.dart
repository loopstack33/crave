// ignore_for_file: camel_case_types, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/signIn/sigininPhone.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_icon_btn.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../home/homeScreen.dart';
import '../signIn/name.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  @override
  State<Welcome_Screen> createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(background), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset(
              craveLogo,
              width: 80.w,
              height: 65.h,
            ),
            const Spacer(flex: 3),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: <TextSpan>[
                TextSpan(
                  text: ' The app that will\n',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 32.sp),
                ),
                TextSpan(
                  text: ' have you',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 32.sp),
                ),
                TextSpan(
                  text: ' CRAVING\n',
                  style: TextStyle(
                      color: AppColors.redcolor,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 32.sp),
                ),
                TextSpan(
                  text: ' for more...',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 32.sp),
                ),
              ]),
            ),
            SizedBox(height: 30.h),
            text(context, "The Ultimate Hookup App", 19.sp,
                color: const Color(0xffF5F5F5).withOpacity(0.5),
                boldText: FontWeight.w200,
                fontFamily: "Roboto-Light"),
            SizedBox(height: 40.h),
            DefaultIconButton(
                iconColor: AppColors.redcolor,
                icon: FontAwesomeIcons.phone,
                weight: FontWeight.w500,
                color: AppColors.black,
                fontFamily: "Roboto-Medium",
                text: "Continue with Phone",
                press: () {
                  AppRoutes.push(context, PageTransitionType.fade,
                      const SigninPhoneValid());
                },
                size: 18.sp),
            SizedBox(
              height: 10.h,
            ),
            /*  DefaultIconButton(
                iconColor: AppColors.black,
                icon: FontAwesomeIcons.apple,
                weight: FontWeight.w500,
                color: AppColors.black,
                fontFamily: "Roboto-Medium",
                text: "Continue with Apple",
                press: () async{
                 //  SharedPreferences prefs = await SharedPreferences.getInstance();
                 // var id= prefs.setString("uid", "u6coYqu73tgQR59lXzyLngtyLJ42");
                 // log(id.toString());
                  AppRoutes.push(context, PageTransitionType.topToBottom,
                      const SigninPhoneValid());
                 // AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade,const HomeScreen());
                },
                size: 18.sp),*/
            (Platform.isIOS)
                ? loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.redcolor),
                      )
                    : SizedBox(
                        width: 320.w,
                        height: 56.h,
                        child: SignInWithAppleButton(
                          borderRadius: BorderRadius.circular(10),
                          text: 'Continue with Apple',
                          onPressed: () async {
                            if (mounted) {
                              setState(() {
                                loading = true;
                              });
                            }
                            signinApple(context);
                          },
                        ),
                      )
                : SizedBox(
                    height: 30.h,
                  ),
            SizedBox(height: 30.h),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: <TextSpan>[
                TextSpan(
                  text: ' By registering, you agree to our',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Regular',
                      fontSize: 11.sp),
                ),
                TextSpan(
                  text: ' Terms of Service,\n',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 11.sp),
                ),
                TextSpan(
                  text: ' Privacy Policy and',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Regular',
                      fontSize: 11.sp),
                ),
                TextSpan(
                  text: ' Cookie Policy',
                  style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Roboto-Bold',
                      fontSize: 11.sp),
                ),
              ]),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  signinApple(BuildContext context) async {
    if (!await SignInWithApple.isAvailable()) {
      ToastUtils.showCustomToast(
          context, "This Device is not eligible for Apple Sign in", Colors.red);
      return null;
    }

    final res = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ]);

    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
        idToken: res.identityToken, accessToken: res.authorizationCode);
    bool check = await userExists(AppleIDAuthorizationScopes.email.toString());
    Future.delayed(const Duration(seconds: 2),
        () => signInWithPhoneAuthCredential(credential, check));

    print(res.state);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  var instance = FirebaseFirestore.instance;

  Future<bool> userExists(String email) async => (await instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get())
      .docs
      .isNotEmpty;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signInWithPhoneAuthCredential(
      OAuthCredential phoneAuthCredential, bool email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        if (email == true) {
          if (mounted) {
            ToastUtils.showCustomToast(context, "Login Success", Colors.green);
            updateDeviceToken(_auth.currentUser!.uid, 'users');
            preferences.setString("logStatus", "true");
            preferences.setString("uid", _auth.currentUser!.uid.toString());
            setState(() {
              loading = false;
            });
            AppRoutes.pushAndRemoveUntil(
                context, PageTransitionType.fade, const HomeScreen());
          }
        } else {
          postDetailsToFirestore(context, email);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, e.message.toString(), Colors.red);
    }
  }

  var deviceToken;

  updateDeviceToken(id, collection) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    var deviceT = await _firebaseMessaging.getToken();
    log(' deviceToken: $deviceT');
    await firebaseFirestore.collection(collection).doc(id).update({
      'deviceToken': deviceT,
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void postDetailsToFirestore(BuildContext context, email) async {
    final auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    var deviceT = await _firebaseMessaging.getToken();
    log(' deviceToken: $deviceT');

    await firebaseFirestore.collection("users").doc(user!.uid).set({
      'uid': user.uid,
      'phone': "",
      'name': '',
      'showName': '',
      'email': AppleIDAuthorizationScopes.email.toString(),
      'deviceToken': deviceT.toString(),
      'craves': [],
      'blocked_By': [],
      'chat_with': [],
      'imageUrl': [],
      'country': '',
      'status': '',
      'age': '',
      'package': '',
      'gender': '',
      'birthday': '',
      'genes': '',
      'bio': '',
      'likedBy': [],
      'steps': '0'
    }).then((value) {
      if (mounted) {
        // ToastUtils.showCustomToast(
        //     context, "Registration Success", Colors.green);
        setState(() {
          loading = false;
        });
        AppRoutes.push(context, PageTransitionType.fade, const FirstName());
      }
      preferences.setString("uid", user.uid.toString());
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
