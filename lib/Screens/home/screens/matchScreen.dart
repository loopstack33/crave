import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    height: 136.h,
                  ),
                ),
                // const Spacer(flex: 1),
                Container(
                  height: 89,
                  width: 89,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    i2,
                    width: 20.w,
                    height: 60.h,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    match22,
                    width: 100.w,
                    height: 136.h,
                  ),
                ),
                const Spacer(flex: 1),
                Padding(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
