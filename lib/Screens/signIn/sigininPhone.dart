import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:crave/Screens/signIn/codeSignin.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SigninPhoneValid extends StatefulWidget {
  SigninPhoneValid({Key? key}) : super(key: key);

  @override
  State<SigninPhoneValid> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<SigninPhoneValid> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CountryCode countryCode = CountryCode.fromDialCode('+86');

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
              text(context, "Enter Phone Number", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.containerborder,
                        width: 2,
                      ),
                      color: AppColors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: CountryCodePicker(
                      onChanged: print,
                      initialSelection: countryCode.toString(),
                      favorite: ['+39', 'FR'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                      width: 200,
                      height: 56.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.containerborder,
                          width: 2,
                        ),
                        color: AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 5, top: 5, right: 5),
                              hintText: "Type here",
                              hintStyle: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 16.sp,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              text(
                  context,
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet in sit tristique purus proin amet tortor. Quamed parturient orci nibh. Tortor diame adipiscing ac, proin neque. Neque ornare sit tristique",
                  11.sp,
                  color: AppColors.textColor,
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Regular"),
              SizedBox(
                height: 30.h,
              ),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                    text: "CONTINUE",
                    press: () {
                      AppRoutes.push(context, PageTransitionType.leftToRight,
                          CodeSignin());
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
}
