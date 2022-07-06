import 'package:crave/Screens/signIn/birthday.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class FirstName extends StatefulWidget {
  const FirstName({Key? key}) : super(key: key);

  @override
  State<FirstName> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<FirstName> {
  bool checkbox = false;
 // Color checkBoxBorder = AppColors.greyShade;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              text(context, "What’s your name?", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 10.h,
              ),
              text(context, "You can only set your name once.", 13.sp,
                  color: AppColors.textColor,
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Regular"),
              SizedBox(
                height: 30.h,
              ),
              Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.containerborder,
                      width: 2,
                    ),
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:const EdgeInsets.only(
                              left: 10, bottom: 5, top: 5, right: 5),
                          hintText: "Enter your first name",
                          hintStyle: TextStyle(
                              fontFamily: "Poppins-Regular",
                              fontSize: 16.sp,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w400)),
                    ),
                  )),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Checkbox(
                      checkColor: AppColors.redcolor,
                      focusColor: AppColors.black,
                      hoverColor: AppColors.containerborder,
                      activeColor: Colors.white,
                      side: BorderSide(
                        color: AppColors.redcolor, //your desire colour here
                        width: 1.5.w,
                      ),
                      value: checkbox,
                      onChanged: _onRememberMeChanged),
                  text(context, "Show my name on my profile", 13.sp,
                      color: AppColors.textColor,
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Align(
                alignment: Alignment.center,
                child: DefaultButton(
                    text: "CONTINUE",
                    press: () {
                      AppRoutes.push(
                          context, PageTransitionType.fade, const BirthdayScreen());
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
    setState((){
      checkbox = newValue;
    });
      });
}
