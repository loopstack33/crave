import 'package:crave/Screens/home/screens/matchedScreens/matchedSuccessful.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
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
              Container(
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
                  AppRoutes.push(
                      context, PageTransitionType.fade, MatchedSuccessed());
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
}
