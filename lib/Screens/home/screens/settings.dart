// ignore_for_file: use_build_context_synchronously

import 'package:crave/Screens/splash/welcome_screen.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Future<void> handleSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("logStatus", "null");
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Welcome_Screen()),
          (Route<dynamic> route) => false,
    );
    ToastUtils.showCustomToast(context, "Logout Successfully", Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: text(context, "Settings", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "Notifications", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "FAQ & Help", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(context, "Community Guidelines", 18.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w500,
                    fontFamily: "Poppins-Medium"),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xffBABABA),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
              onTap: (){
                handleSignOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  text(context, "Log Out", 18.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Poppins-Medium"),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              thickness: 1,
            ),
            const Spacer(flex: 1),
            text(context, "Delete Account", 22.sp,
                color: AppColors.redcolor,
                boldText: FontWeight.w500,
                fontFamily: "Poppins-Medium"),
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              settingbottom,
              width: 108.w,
              height: 18.h,
            ),
          ],
        ),
      ),
    );
  }
}
