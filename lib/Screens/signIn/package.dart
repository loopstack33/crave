import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/splash/creatingProfile.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/utils/sharedPref.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({Key? key}) : super(key: key);

  @override
  State<PackageScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<PackageScreen> {
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  Color genderContainerBorderMan = const Color(0xffE3E3E3);
  Color genderContainerMan = const Color(0xffF3F3F3);
  DateTime date = DateTime(2016, 10, 26);
  String? SelectedPackage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(context, "How much would you pay for an adventure?", 24.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w600,
                    fontFamily: "Poppins-SemiBold"),
                SizedBox(
                  height: 20.h,
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        SelectedPackage = "week";

                        postDetailsToFirestore(context, SelectedPackage);
                      },
                      child: Container(
                        height: 190.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(week), fit: BoxFit.fill)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            text(context, "ONE WEEK", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Regular"),
                            SizedBox(
                              height: 10.h,
                            ),
                            text(context, "\$9.99", 14.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Bold"),
                          ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        SelectedPackage = "month";
                        postDetailsToFirestore(context, SelectedPackage);
                      },
                      child: Container(
                        height: 190.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(month), fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            text(context, "ONE MONTH", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Regular"),
                            SizedBox(
                              height: 10.h,
                            ),
                            text(context, "\$29.99", 14.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Bold"),
                            SizedBox(
                              height: 10.h,
                            ),
                            text(context, "SAVE  \$10", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Regular"),
                          ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        SelectedPackage = "year";
                        postDetailsToFirestore(context, SelectedPackage);
                      },
                      child: Container(
                        height: 190.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(year), fit: BoxFit.cover)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            text(context, "ONE YEAR", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Regular"),
                            SizedBox(
                              height: 10.h,
                            ),
                            text(context, "\$299.99", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Bold"),
                            SizedBox(
                              height: 10.h,
                            ),
                            text(context, "SAVE  \$20", 12.sp,
                                color: AppColors.white,
                                boldText: FontWeight.w400,
                                fontFamily: "Roboto-Regular"),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                text(
                    context,
                    "After purchasing the subscription, your post will appear to the public. You can also see posts from other people. Find someone you like and Have fun!",
                    14.sp,
                    color: const Color(0xff9C9C9C),
                    boldText: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
                SizedBox(
                  height: 10.h,
                ),

                text(
                    context,
                    "You can like anyone around the world. CRAVE has no borders! Tap on the ♥ icon, go chatting and have fun!",
                    14.sp,
                    color: const Color(0xff9C9C9C),
                    boldText: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
                SizedBox(
                  height: 10.h,
                ),
                text(
                    context,
                    "All chats self-destruct in 24 hours.If you want to add more time to the chat timer, it's only \$1.99",
                    14.sp,
                    color: const Color(0xff9C9C9C),
                    boldText: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),
                SizedBox(
                  height: 10.h,
                ),
                text(
                    context,
                    "Try Video Chatting with someone new, tap the 🎥 icon in Chat and get to know someone through the lens of your camera! ",
                    14.sp,
                    color: const Color(0xff9C9C9C),
                    boldText: FontWeight.w400,
                    fontFamily: "Poppins-Regular"),

                loading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.redcolor,
                  ),
                )
                    :const SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Privacy Policy ", 12.sp,
                              color: const Color(0xffAAAAAA),
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Medium"),
                          SizedBox(width: 5.w),
                          Container(
                            height: 12.h,
                            width: 2.w,
                            color: const Color(0xFF565656),
                          ),
                          SizedBox(width: 5.w),
                          text(context, "Terms of Service", 12.sp,
                              color: const Color(0xffAAAAAA),
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Medium"),
                        ],
                      ),
                    )),

                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void postDetailsToFirestore(BuildContext context, package) async {
    if(mounted){
      setState((){
        loading =true;
      });
    }
    final _auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'package': package,
    }).then((text) {
      if (mounted) {
        ToastUtils.showCustomToast(context, "package Added", Colors.green);
        setState(() {
          loading = false;
        });
        preferences.setString("package", package);
        AppRoutes.push(
            context, PageTransitionType.fade, const CreatingProfileScreen());
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
