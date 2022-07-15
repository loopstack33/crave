import 'package:age_calculator/age_calculator.dart';
import 'package:crave/Screens/signIn/gender.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({Key? key}) : super(key: key);

  @override
  State<BirthdayScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<BirthdayScreen> {
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  DateTime date = DateTime(2010, 10, 26);
  DateDuration? duration;
  String age = "your age";
  Color btnColor = const Color(0xFFE38282);
  @override
  void initState() {
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
              text(context, "What’s your birthday?", 24.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w600,
                  fontFamily: "Poppins-SemiBold"),
              SizedBox(
                height: 10.h,
              ),
              text(
                  context, "Your birthday won’t be visible to \nothers.", 15.sp,
                  color: AppColors.textColor2.withOpacity(0.72),
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Regular"),
              SizedBox(
                height: 30.h,
              ),
              //calender
              SizedBox(
                height: 270,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                          color: AppColors.black,
                          fontFamily: 'Poppins-Medium',
                          fontSize: 19.sp),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: date,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        date = newDate;
                        duration = AgeCalculator.age(date);
                        age = duration!.years.toString();
                        print('Your age is $duration');
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.center,
                child: text(context, "Age ${age}", 22.sp,
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
                    color: age == "your age" ? btnColor : AppColors.redcolor,
                    press: age != "your age"
                        ? () {
                            var checkAge = int.parse(age);
                            if (checkAge <= 0 || checkAge < 18) {
                              ToastUtils.showCustomToast(
                                  context, "Correct Age", Colors.red);
                            } else {
                              AppRoutes.push(context, PageTransitionType.fade,
                                  const GenderScreen());
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
}
