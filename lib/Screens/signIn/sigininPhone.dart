// ignore_for_file: file_names

import 'package:country_code_picker/country_code_picker.dart';
import 'package:crave/Screens/signIn/codeSignin.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/custom_toast.dart';

class SigninPhoneValid extends StatefulWidget {
  const SigninPhoneValid({Key? key}) : super(key: key);

  @override
  State<SigninPhoneValid> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<SigninPhoneValid> {
  ///VARIABLES AND DECLARATION
  CountryCode countryCode = CountryCode.fromDialCode('+1');

  bool loading = false;
  bool isEnabled = false;
  TextEditingController phone = TextEditingController();
  //Initialize a button color variable
  Color btnColor = const Color(0xFFE38282);

  @override
  Widget build(BuildContext context) {
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
        title: Image.asset(
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
                      padding: const EdgeInsets.all(2),
                      textStyle: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16.sp,
                          color: AppColors.textColor),
                      onChanged: (code) {
                        if (mounted) {
                          setState(() {
                            countryCode = code;
                          });
                        }
                      },
                      initialSelection: 'US',
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.57,
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
                        onChanged: (text) {
                          if (mounted) {
                            setState(() {
                              if (text.isNotEmpty) {
                                isEnabled = true;
                                btnColor = AppColors.redcolor;
                              } else {
                                isEnabled = false;
                                btnColor = const Color(0xFFE38282);
                              }
                            });
                          }
                        },
                        controller: phone,
                        cursorColor: AppColors.redcolor,
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 16.sp,
                            color: AppColors.textColor),
                        textAlignVertical: TextAlignVertical.top,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
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
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'By providing my phone number, I hereby agree and accept the ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: "Poppins-Regular",
                            color: AppColors.textColor),
                      ),
                      TextSpan(
                        text: ' Terms of Services',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: "Poppins-Regular",
                            color: AppColors.textColor),
                      ),
                      TextSpan(
                        text: ' and',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: "Poppins-Regular",
                            color: AppColors.textColor),
                      ),
                      TextSpan(
                        text: ' Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: "Poppins-Regular",
                            color: AppColors.textColor),
                      ),
                      TextSpan(
                        text: ' of this app',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: "Poppins-Regular",
                            color: AppColors.textColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Align(
                alignment: Alignment.center,
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.redcolor,
                        ),
                      )
                    : DefaultButton(
                        text: "CONTINUE",
                        color: btnColor,
                        press: isEnabled
                            ? () async {
                                if (mounted) {
                                  setState(() {
                                    loading = true;
                                  });
                                }
                                if (phone.text.isEmpty) {
                                  ToastUtils.showCustomToast(
                                      context,
                                      "Please enter number",
                                      AppColors.redcolor);
                                  if (mounted) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                } else {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: countryCode.toString() +
                                        phone.text.toString().replaceAll(
                                            RegExp(r'^0+(?=.)'), ''),
                                    verificationCompleted: (PhoneAuthCredential
                                        credential) async {},
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                      ToastUtils.showCustomToast(
                                          context, e.toString(), Colors.red);
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      // ToastUtils.showCustomToast(
                                      //     context, "Code Sent", Colors.green);
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                      AppRoutes.push(
                                          context,
                                          PageTransitionType.fade,
                                          CodeSignin(
                                              isTimeOut2: false,
                                              phone: countryCode.toString() +
                                                  phone.text
                                                      .toString()
                                                      .replaceAll(
                                                          RegExp(r'^0+(?=.)'),
                                                          '')
                                                      .toString(),
                                              verifyId: verificationId));
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {
                                      if (mounted) {
                                        setState(() {
                                          loading = false;
                                        });
                                      }
                                    },
                                  );
                                }
                              }
                            : () {}),
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
