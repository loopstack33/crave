// ignore_for_file: file_names

import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MatchedSuccessed extends StatefulWidget {
  const MatchedSuccessed({Key? key}) : super(key: key);

  @override
  State<MatchedSuccessed> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchedSuccessed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        //automaticallyImplyLeading: false,
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
        decoration: const BoxDecoration(
          color: Color(0xff191919),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Spacer(flex: 1),
            text(context, "YOU MATCHED!", 28.sp,
                color: Colors.white.withOpacity(0.58),
                fontFamily: "Poppins-Bold"),
            const Spacer(flex: 1),
            Stack(
              children: [
                Image.asset("assets/raw/stars.gif"),
               // Lottie.asset(stars),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    matchedgirl,
                    width: 290.w,
                    height: 270.h,
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 160,
                  child: Image.asset(
                    matchedboy,
                    width: 220.w,
                    height: 230.h,
                  ),
                ),

              ],
            ),
            const Spacer(flex: 1),
            DefaultButton(text: "START CHAT", press: () {}),
            SizedBox(
              height: 20.h,
            ),
            text(context, "I want another match", 18.sp,
                color: Colors.white,
                boldText: FontWeight.w500,
                fontFamily: "Poppins-Medium"),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
