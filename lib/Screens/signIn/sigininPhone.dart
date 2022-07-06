// ignore_for_file: file_names

import 'package:country_code_picker/country_code_picker.dart';
import 'package:crave/Screens/signIn/codeSignin.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class SigninPhoneValid extends StatefulWidget {
  const SigninPhoneValid({Key? key}) : super(key: key);

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
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
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
        title:Image.asset(
          hLogo,
          width: 105.w,
          height: 18.h,
        ),
        centerTitle: true,
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
                      padding:const EdgeInsets.all(2),
                      textStyle: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 16.sp, color: AppColors.textColor),
                      onChanged: print,
                      initialSelection: countryCode.toString(),
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
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder:InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:const EdgeInsets.only(
                                left: 10, bottom: 5, top: 5, right: 5),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontSize: 16.sp,
                                color: AppColors.textColor)),
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
                      AppRoutes.push(
                          context, PageTransitionType.fade, const CodeSignin());
                    }),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
