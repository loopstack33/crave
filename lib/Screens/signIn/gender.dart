import 'package:country_code_picker/country_code_picker.dart';
import 'package:crave/Screens/signIn/codeSignin.dart';
import 'package:crave/Screens/signIn/genderOption.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class GenderScreen extends StatefulWidget {
  GenderScreen({Key? key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<GenderScreen> {
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  Color genderContainerBorderMan = Color(0xffE3E3E3);
  Color genderContainerMan = Color(0xffF3F3F3);
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
            text(context, "  C R A V E        ", 24.sp,
                color: AppColors.redcolor,
                boldText: FontWeight.w600,
                fontFamily: "Poppins-Semi-Bold"),
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
              text(context, "Your Gender...", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: genderContainerBorderMan, width: 1),
                        color: genderContainerMan,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Man", 20.sp,
                              color: AppColors.greyShade,
                              boldText: FontWeight.w600,
                              fontFamily: "Poppins-SemiBold"),
                          Image.asset(
                            male,
                            width: 74.w,
                            height: 121.h,
                          ),
                        ]),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Container(
                    width: 150.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: genderContainerBorderMan, width: 1),
                        color: genderContainerMan,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Woman", 20.sp,
                              color: AppColors.greyShade,
                              boldText: FontWeight.w600,
                              fontFamily: "Poppins-SemiBold"),
                          Image.asset(
                            female,
                            width: 74.w,
                            height: 121.h,
                          ),
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: genderContainerBorderMan, width: 1),
                        color: genderContainerMan,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Others", 20.sp,
                              color: AppColors.greyShade,
                              boldText: FontWeight.w600,
                              fontFamily: "Poppins-SemiBold"),
                          Image.asset(
                            other,
                            width: 74.w,
                            height: 121.h,
                          ),
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                    text: "NEXT",
                    press: () {
                      AppRoutes.push(context, PageTransitionType.leftToRight,
                          GenderOption());
                    }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
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
                      height: 10,
                      width: 10,
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
                      height: 10,
                      width: 10,
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
                      height: 10,
                      width: 10,
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
                      height: 10,
                      width: 10,
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
                      height: 10,
                      width: 10,
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
