// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/signIn/package.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenderOption extends StatefulWidget {
  const GenderOption({Key? key}) : super(key: key);

  @override
  State<GenderOption> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<GenderOption> {
  bool heterob = false;
  bool lesbianb = false;
  bool gayb = false;
  bool bisexualb = false;
  String? sexuality;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;
  Color lightRedContainer = const Color(0xffFFE9E9);
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  Color genderContainerBorderMan = const Color(0xffE3E3E3);
  Color genderContainerMan = const Color(0xffF3F3F3);
  DateTime date = DateTime(2016, 10, 26);
  Color btnColor = const Color(0xFFE38282);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
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
        title: Image.asset(
          hLogo,
          width: 105.w,
          height: 18.h,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(context, "I am a...", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (lesbianb == true ||
                            gayb == true ||
                            bisexualb == true) {
                          lesbianb = false;
                          gayb = false;
                          bisexualb = false;
                          heterob = true;
                          sexuality = "Hetero";
                        } else {
                          heterob = true;
                          sexuality = "Hetero";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: heterob
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color:
                              heterob ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(context, "Hetero", 20.sp,
                                color: heterob
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                fontFamily: "Poppins-Medium"),
                            Image.asset(
                              hetero,
                              width: 74.w,
                              height: 121.h,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (heterob == true ||
                            gayb == true ||
                            bisexualb == true) {
                          heterob = false;
                          gayb = false;
                          bisexualb = false;
                          lesbianb = true;
                          sexuality = "Lesbian";
                        } else {
                          lesbianb = true;
                          sexuality = "Lesbian";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: lesbianb
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color:
                              lesbianb ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(context, "Lesbian", 20.sp,
                                color: lesbianb
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                fontFamily: "Poppins-Medium"),
                            Image.asset(
                              lesbian,
                              width: 74.w,
                              height: 121.h,
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (lesbianb == true ||
                            heterob == true ||
                            bisexualb == true) {
                          lesbianb = false;
                          heterob = false;
                          bisexualb = false;
                          gayb = true;
                          sexuality = "Gay";
                        } else {
                          gayb = true;
                          sexuality = "Gay";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: gayb
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color: gayb ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(context, "Gay", 20.sp,
                                color: gayb
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                fontFamily: "Poppins-Medium"),
                            Image.asset(
                              gay,
                              width: 74.w,
                              height: 121.h,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (lesbianb == true ||
                            gayb == true ||
                            heterob == true) {
                          lesbianb = false;
                          gayb = false;
                          heterob = false;
                          bisexualb = true;
                          sexuality = "Bisexual";
                        } else {
                          bisexualb = true;
                          sexuality = "Bisexual";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: bisexualb
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color: bisexualb
                              ? lightRedContainer
                              : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(context, "Bisexual", 20.sp,
                                color: bisexualb
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                fontFamily: "Poppins-Medium"),
                            Image.asset(
                              bisexual,
                              width: 74.w,
                              height: 121.h,
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                    text: "NEXT",
                    color: sexuality != null ? AppColors.redcolor : btnColor,
                    press: sexuality != null
                        ? () {
                            if (heterob == true ||
                                lesbianb == true ||
                                gayb == true ||
                                bisexualb == true ||
                                sexuality != null) {
                              postDetailsToFirestore(context, sexuality);
                            } else {
                              ToastUtils.showCustomToast(
                                  context, "choose gender Option", Colors.red);
                            }
                          }
                        : () {}),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.greyLightShade,
                        border: Border.all(
                          color: AppColors.greyLightShade,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.greyLightShade,
                        border: Border.all(
                          color: AppColors.greyLightShade,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.greyLightShade,
                        border: Border.all(
                          color: AppColors.greyLightShade,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.greyLightShade,
                        border: Border.all(
                          color: AppColors.greyLightShade,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.greyLightShade,
                        border: Border.all(
                          color: AppColors.greyLightShade,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.redcolor,
                        border: Border.all(
                          color: AppColors.redcolor,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void postDetailsToFirestore(BuildContext context, gene) async {
    final _auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'genes': gene,
    }).then((text) {
      if (mounted) {
        ToastUtils.showCustomToast(context, "gender Added", Colors.green);
        setState(() {
          loading = false;
        });
        preferences.setString("gene", gene);
        AppRoutes.push(context, PageTransitionType.fade, const PackageScreen());
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
