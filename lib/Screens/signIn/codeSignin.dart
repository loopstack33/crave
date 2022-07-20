// ignore_for_file: file_names, prefer_function_declarations_over_variables, use_build_context_synchronously, must_be_immutable, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/homeScreen.dart';
import 'package:crave/Screens/signIn/name.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_toast.dart';
import 'birthday.dart';
import 'createProfile.dart';
import 'gender.dart';
import 'genderOption.dart';
import 'package.dart';

class CodeSignin extends StatefulWidget {
  String phone;
  bool isTimeOut2;
  String verifyId;
  CodeSignin(
      {Key? key,
      required this.phone,
      required this.verifyId,
      required this.isTimeOut2})
      : super(key: key);

  @override
  State<CodeSignin> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<CodeSignin> {
  ///VARIABLES AND DECLARATION
  TextEditingController otpController = TextEditingController();
  bool verifyText = false;
  bool loading = false;
  bool isTimeOut = false;
  String myVerificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int start = 60;
  bool wait = false;
  String verificationIdFinal = "";
  //Initialize a button color variable
  Color btnColor = const Color(0xFFE38282);
  bool isEnabled = false;

  var instance = FirebaseFirestore.instance;

  var exists;
  doesUserExist(phone) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get()
          .then((value) => value.size > 0 ? setState((){
            getUser();
            exists = true;
      }) : setState((){
        exists = false;
      }));
    } catch (e) {
      debugPrint(e.toString());

    }
  }
  String step='';
  getUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value){
            if(mounted){
              setState((){
                step =value.data()!["steps"];
                log(step.toString());
              });
            }
         });
    } catch (e) {
      debugPrint(e.toString());

    }
  }


  @override
  void initState() {
    super.initState();
    myVerificationId = widget.verifyId;
    isTimeOut = widget.isTimeOut2;
    startTimer();
    doesUserExist(widget.phone);

  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
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
          title: Image.asset(
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
                  androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsRetrieverApi,
                  length: 6,
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
                      border: Border.all(
                          color: AppColors.containerborder, width: 2.w),
                    ),
                  ),
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
                  controller: otpController,
                  forceErrorState: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  validator: (pin) {
                    if (pin!.length < 6) {
                      return "You should enter all SMS code";
                    } else {
                      return null;
                    }
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
                  text(context, widget.phone.toString(), 11.sp,
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
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.redcolor,
                          ),
                        )
                      : DefaultButton(
                          color: btnColor,
                          text: "VERIFY",
                          press: isEnabled
                              ? () {
                            if (otpController.text.isEmpty) {
                              ToastUtils.showCustomToast(
                                  context,
                                  "Please enter six digit code",
                                  AppColors.redcolor);
                              if (mounted) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            }
                            else{
                              PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: myVerificationId,
                                  smsCode: otpController.text);

                              signInWithPhoneAuthCredential(
                                  phoneAuthCredential);

                            }

                                }
                              : () {})),
              SizedBox(
                height: 10.h,
              ),
              verifyText == false
                  ? const SizedBox.shrink()
                  : Center(
                      child: Text(
                        "Successful!",
                        style: TextStyle(
                            fontFamily: 'Poppins-SemiBold',
                            fontSize: 16.sp,
                            color: const Color.fromARGB(255, 45, 253, 52)),
                        textAlign: TextAlign.center,
                      ),
                    ),
              SizedBox(
                height: 20.h,
              ),
              verifyText == true
                  ? Center(
                      child: Text(
                        "Didn't you receive any code?",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.bbColor),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 30.h,
              ),
              start == 0
                  ? verifyText == true
                      ? Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: wait
                                ? null
                                : () async {
                                    if (mounted) {
                                      setState(() {
                                        verifyText = false;
                                        start = 60;
                                        wait = true;
                                        loading = true;
                                      });
                                    }
                                    await verifyPhoneNumber(
                                        widget.phone.toString(),
                                        context,
                                        setData);
                                  },
                            child: Container(
                              width: 105.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 13.r,
                                        offset: const Offset(0, 4),
                                        color: AppColors.shahdowColor
                                            .withOpacity(0.25))
                                  ],
                                  border: Border.all(
                                      color: AppColors.black, width: 1),
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
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
                        )
                      : const SizedBox()
                  : const SizedBox(),
              SizedBox(
                height: 10.h,
              ),
              start.toString() != "0"
                  ? Center(
                      child: Text(
                        "Resend code in 00:$start sec",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: AppColors.bbColor),
                      ),
                    )
                  : const SizedBox(),
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        if (mounted) {
          setState(() {
            verifyText = true;
          });
        }
        if(exists==true){
          if(step =="0"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const FirstName());
            }
          }
          else if(step =="1"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const BirthdayScreen());
            }
          }
          else if(step =="2"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const GenderScreen());
            }
          }
          else if(step =="3"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const GenderOption());
            }
          }
          else if(step =="4"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const PackageScreen());
            }
          }
          else if(step =="5"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Complete your registration", Colors.red);
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade, const CreateProfile());
            }
          }
          else if(step =="6"){
            if (mounted) {
              ToastUtils.showCustomToast(
                  context, "Login Success", Colors.green);
              preferences.setString("logStatus", "true");
              setState(() {
                loading = false;
              });
              AppRoutes.pushAndRemoveUntil(context, PageTransitionType.fade,const HomeScreen());

            }
          }

        }
        else{
          postDetailsToFirestore(context, widget.phone.toString());
        }

      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, e.message.toString(), Colors.red);
    }
  }

  Timer? _timer;
  void startTimer() {
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        if (mounted) {
          setState(() {
            timer.cancel();
            _timer!.cancel();
            wait = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            start--;
          });
        }
      }
    });
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      ToastUtils.showCustomToast(
          context, "Verification Completed", Colors.green);
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, exception.toString(), Colors.red);
    };
    PhoneCodeSent codeSent = (String verificationId, int? resendToken) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(
          context, "Verification Code sent on the phone number", Colors.green);

      setData(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, "Code TimeOut", Colors.red);
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      ToastUtils.showCustomToast(context, e.toString(), Colors.red);
    }
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }

  void postDetailsToFirestore(BuildContext context, phone) async {
    final auth = FirebaseAuth.instance;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).set({
      'uid': user.uid,
      'phone': phone,
      'name': '',
      'showName': '',
      'deviceToken': "",
      'craves':[],
      'imageUrl':[],
      'country':'',
      'status': '',
      'age': '',
      'gender': '',
      'birthday': '',
      'genes': '',
      'bio': '',
      'reportedBy':[],
       'steps':'0'
    }).then((value) {
      if (mounted) {
        ToastUtils.showCustomToast(
            context, "Registration Success", Colors.green);
        setState(() {
          loading = false;
        });
        AppRoutes.push(context, PageTransitionType.fade, const FirstName());
      }
      // preferences.setString("logStatus", "true");
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
