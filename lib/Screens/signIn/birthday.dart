import 'package:country_code_picker/country_code_picker.dart';
import 'package:crave/Screens/signIn/codeSignin.dart';
import 'package:crave/Screens/signIn/gender.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class BirthdayScreen extends StatefulWidget {
  BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<BirthdayScreen> {
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  DateTime date = DateTime(2016, 10, 26);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoRed,
              width: 36.w,
              height: 18.h,
            ),
            // SizedBox(
            //   width: 5.w,
            // ),
            text(context, "  C R A V E             ", 15.sp,
                color: AppColors.redcolor,
                boldText: FontWeight.w600,
                fontFamily: "Roboto-Medium"),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(context, "What’s your birthday?", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 20.h,
              ),
              text(context, "Your birthday won’t be visible to others.", 15.sp,
                  color: AppColors.textColor,
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Regular"),
              SizedBox(
                height: 30.h,
              ),
              //calender
              Container(
                height: 270,
                child: CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  // This is called when the user changes the date.
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => date = newDate);
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: text(context, "Age 1", 22.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w600,
                    fontFamily: "Poppins-SemiBold"),
              ),
              SizedBox(
                height: 20.h,
              ),

              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                    text: "NEXT",
                    press: () {
                      AppRoutes.push(
                          context, PageTransitionType.fade, GenderScreen());
                    }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
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

  void _onRememberMeChanged(newValue) => setState(() {
        checkbox = newValue;

        if (checkbox) {
          checkBoxBorder = AppColors.redcolor;
        } else {}
      });
}
