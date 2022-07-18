import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/signIn/genderOption.dart';
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

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<GenderScreen> {
  Color btnColor = const Color(0xFFE38282);
  String? gender;
  bool man = false;
  bool woman = false;
  bool others = false;
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  Color genderContainerBorderMan = const Color(0xffE3E3E3);
  Color genderContainerMan = const Color(0xffF3F3F3);
  Color lightRedContainer = const Color(0xffFFE9E9);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;
  DateTime date = DateTime(2016, 10, 26);
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
              text(context, "Your Gender...", 24.sp,
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
                        if (woman == true || others == true) {
                          woman = false;
                          others = false;
                          man = true;
                          gender = "Man";
                        } else {
                          man = true;
                          gender = "Man";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: man
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color: man ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            text(context, "Man", 20.sp,
                                color: man
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                boldText: FontWeight.w600,
                                fontFamily: "Poppins-SemiBold"),
                            SizedBox(height: 10.h),
                            Image.asset(
                              male,
                              width: 74.w,
                              //  height: 121.h,
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
                        if (man == true || others == true) {
                          man = false;
                          others = false;
                          woman = true;
                          gender = "Woman";
                        } else {
                          woman = true;
                          gender = "Woman";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: woman
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color: woman ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            text(context, "Woman", 20.sp,
                                color: woman
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                boldText: FontWeight.w600,
                                fontFamily: "Poppins-SemiBold"),
                            SizedBox(height: 10.h),
                            Image.asset(
                              female,
                              width: 74.w,
                              // height: 121.h,
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
                        if (man == true || woman == true) {
                          woman = false;
                          man = false;
                          others = true;
                          gender = "Other";
                        } else {
                          others = true;
                          gender = "Other";
                        }
                      });
                    },
                    child: Container(
                      width: 150.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: others
                                  ? AppColors.redcolor
                                  : genderContainerBorderMan,
                              width: 1),
                          color:
                              others ? lightRedContainer : genderContainerMan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            text(context, "Other", 20.sp,
                                color: others
                                    ? AppColors.redcolor
                                    : AppColors.greyShade,
                                boldText: FontWeight.w600,
                                fontFamily: "Poppins-SemiBold"),
                            SizedBox(height: 10.h),
                            Image.asset(
                              other,
                              width: 74.w,
                              //   height: 121.h,
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
                child: loading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.redcolor,
                  ),
                )
                    :  DefaultButton(
                    text: "NEXT",
                    color: gender != null ? AppColors.redcolor : btnColor,
                    press: gender != null
                        ? () {
                            if (man == true ||
                                woman == true ||
                                others == true ||
                                gender != null) {
                              if(mounted){
                                setState((){
                                  loading = true;
                                });
                              }
                              postDetailsToFirestore(context, gender);
                            } else {
                              if(mounted){
                                setState((){
                                  loading = false;
                                });
                              }
                              ToastUtils.showCustomToast(context, "Choose a Gender", AppColors.redcolor);
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
                        color: AppColors.redcolor,
                        border: Border.all(
                          color: AppColors.redcolor,
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void postDetailsToFirestore(BuildContext context, genderb) async {
    final _auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'gender': genderb,
      'steps':'3',
    }).then((text) {
      if (mounted) {
        ToastUtils.showCustomToast(context, "gender Added", Colors.green);
        setState(() {
          loading = false;
        });
        preferences.setString("gender", genderb);
        AppRoutes.push(context, PageTransitionType.fade, const GenderOption());
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
