// ignore_for_file: file_names

import 'package:crave/Screens/home/homeScreen.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/app_routes.dart';

class CreatingProfileScreen extends StatefulWidget {
  const CreatingProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreatingProfileScreen> createState() => _CreatingProfileScreenState();
}

class _CreatingProfileScreenState extends State<CreatingProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      AppRoutes.pushAndRemoveUntil(
          context, PageTransitionType.fade, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: text(context, "Creating your profile...", 24.sp,
                color: AppColors.black,
                boldText: FontWeight.w600,
                fontFamily: "Poppins-SemiBold"),
          ),
          SizedBox(
            height: 50.h,
          ),
          Image.asset(
            gif1,
            width: 100.w,
            height: 100.h,
            color: AppColors.grey1,
          ),
        ],
      ),
    );
  }
}
