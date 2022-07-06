// ignore_for_file: file_names
import 'package:crave/Screens/signIn/name.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class CodeSignin extends StatefulWidget {
  const CodeSignin({Key? key}) : super(key: key);

  @override
  State<CodeSignin> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<CodeSignin> {
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(context, "Verify Phone Number", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Pinput(
                  length: 5,
                  defaultPinTheme: PinTheme(
                    width: 55.w,
                    height: 55.h,
                    textStyle: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Poppins-SemiBold',
                        color: AppColors.black,
                        fontWeight: FontWeight.w500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.white,
                      border: Border.all(color: AppColors.containerborder,width: 2.w),
                    ),
                  ),
                  controller: otpController,
                  forceErrorState: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (pin) {
                  /*  if (pin!.length < 4) {
                      return "You should enter all SMS code";
                    } else {
                      return null;
                    }*/
                  },
                ),
              ),

              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(context, "Enter the code sent to", 11.sp,
                      color: AppColors.textColor,
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                  SizedBox(
                    width: 5.w,
                  ),
                  text(context, " 401  60X - 5XXX", 11.sp,
                      color: AppColors.textColor,
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-SemiBold"),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 105.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 13.r,
                          offset:const Offset(0,4),
                          color: AppColors.shahdowColor.withOpacity(0.25)
                        )
                      ],
                        border: Border.all(color: AppColors.black, width: 1),
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child:  Center(
                      child: Text(
                        "Resend",
                        style: TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontSize: 16.sp,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                  alignment: Alignment.center,
                  child: DefaultButton(
                      text: "VERIFY",
                      press: () {
                        AppRoutes.push(
                            context, PageTransitionType.fade, const FirstName());
                      })),
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
