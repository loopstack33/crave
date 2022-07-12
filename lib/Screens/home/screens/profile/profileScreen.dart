// ignore_for_file: file_names

import 'package:crave/Screens/home/screens/profile/mycraves.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.white,
        title: text(context, "Edit Profile", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  forehead,
                  width: MediaQuery.of(context).size.width,
                  height: 96.w,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 145,
                      width: 137,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        editprofileimage,
                        width: 20.w,
                        height: 60.h,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 215,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        cameraEdit,
                        width: 20.2.w,
                        height: 16.19.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            text(context, "Daniel, 28", 28.sp,
                color: const Color(0xff606060),
                boldText: FontWeight.w500,
                fontFamily: "Poppins-SemiBold"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  locationicon,
                  width: 16.w,
                  height: 16.h,
                ),
                text(context, "California, USA", 14.sp,
                    color: const Color(0xff606060),
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                text(context, "ABOUT ME", 16.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-SemiBold"),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 136,
              width: 326,
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Center(
                  child: text(
                      context,
                      "Lorem Ipsum is simply dummy text of the printingand typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                      14.sp,
                      color: Color(0xff636363),
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 255.h,
              width: 335.w,
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          mycraves,
                          width: 114.w,
                          height: 22.h,
                        ),
                        InkWell(
                          onTap: () {
                            AppRoutes.push(
                                context, PageTransitionType.fade, MyCraves());
                          },
                          child: Container(
                            height: 35.h,
                            width: 85.w,
                            decoration: BoxDecoration(
                              color: AppColors.redcolor,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Add", 16.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Kinky", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      kinky,
                                      width: 14.w,
                                      height: 16.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Casual Dating", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    casualdating,
                                    width: 12.w,
                                    height: 16.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Submissive", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      submissive,
                                      width: 14.w,
                                      height: 16.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "In Person", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    inperson,
                                    width: 12.w,
                                    height: 16.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Dirty Talk", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      dirtytalk,
                                      width: 14.w,
                                      height: 16.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Color(0xff464646),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text(context, "Vanilla", 12.sp,
                                    color: AppColors.white,
                                    boldText: FontWeight.w400,
                                    fontFamily: "Poppins-Regular"),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff545454),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    vanilla,
                                    width: 12.w,
                                    height: 16.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Image.asset(
                                  cross,
                                  width: 19.w,
                                  height: 19.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            text(context, "Disable Account", 20.sp,
                color: AppColors.black,
                boldText: FontWeight.w400,
                fontFamily: "Poppins-Medium"),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
