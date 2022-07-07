// ignore_for_file: camel_case_types

import 'package:crave/Screens/signIn/sigininPhone.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_icon_btn.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../home/homeScreen.dart';

class Welcome_Screen extends StatelessWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

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
                  AppRoutes.push(context, PageTransitionType.topToBottom,
                      const HomeScreen());
                },
                size: 18.sp),
            SizedBox(
              height: 10.h,
            ),
            DefaultIconButton(
                iconColor: AppColors.black,
                icon: FontAwesomeIcons.apple,
                weight: FontWeight.w500,
                color: AppColors.black,
                fontFamily: "Roboto-Medium",
                text: "Continue with Apple",
                press: () {
                  AppRoutes.push(context, PageTransitionType.topToBottom,
                      const SigninPhoneValid());
                },
                size: 18.sp),
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
}
