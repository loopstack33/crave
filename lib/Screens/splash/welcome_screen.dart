import 'package:crave/Screens/signIn/sigininPhone.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class Welcome_Screen extends StatelessWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Spacer(
              flex: 2,
            ),
            Image.asset(
              logoRed,
              width: 80.w,
              height: 40.h,
            ),
            text(context, "C R A V E", 16.sp,
                color: AppColors.white,
                boldText: FontWeight.w600,
                fontFamily: "Roboto-Bold"),
            Spacer(
              flex: 3,
            ),
            text(context, "The app that will", 32.sp,
                color: AppColors.white,
                boldText: FontWeight.w900,
                fontFamily: "Roboto-Bold"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(context, "have you", 32.sp,
                    color: AppColors.white,
                    boldText: FontWeight.w900,
                    fontFamily: "Roboto-Bold"),
                text(context, " CRAVING", 32.sp,
                    color: AppColors.redcolor,
                    boldText: FontWeight.w900,
                    fontFamily: "Roboto-Black"),
              ],
            ),
            text(context, "for more...", 32.sp,
                color: AppColors.white,
                boldText: FontWeight.w900,
                fontFamily: "Roboto-Bold"),
            Container(color: Colors.transparent, height: 40, child: Spacer()),
            text(context, "The Ultimate Hookup App", 19.sp,
                color: const Color(0xffF5F5F5).withOpacity(0.5),
                boldText: FontWeight.w200,
                fontFamily: "Roboto-Light"),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                AppRoutes.push(
                    context, PageTransitionType.fade, SigninPhoneValid());
              },
              child: Container(
                  width: 320.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.phone,
                        color: AppColors.redcolor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      text(context, "Continue with Phone", 18.sp,
                          color: AppColors.black, fontFamily: "Roboto-Medium"),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  width: 320.w,
                  height: 56.h,
                  decoration: BoxDecoration(

                      // boxShadow: [
                      //   BoxShadow(blurRadius: 12, color: black.withOpacity(0.25))
                      // ],
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.apple,
                        color: AppColors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      text(context, "Continue with Apple", 18.sp,
                          color: AppColors.black, fontFamily: "Roboto-Medium"),
                    ],
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),
            text(context, "By registering, you agree to our Terms of Service,",
                11.sp,
                color: const Color(0xffF5F5F5),
                boldText: FontWeight.w700,
                fontFamily: "Roboto-Regular"),
            text(context, " Privacy Policy and Cookie Policy", 11.sp,
                color: const Color(0xffF5F5F5),
                boldText: FontWeight.w700,
                fontFamily: "Roboto-Regular"),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
