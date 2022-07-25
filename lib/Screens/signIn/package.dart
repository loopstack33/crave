// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/signIn/createProfile.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:crave/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pay/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({Key? key}) : super(key: key);

  @override
  State<PackageScreen> createState() => _SigninPhoneValidState();
}

class _SigninPhoneValidState extends State<PackageScreen> {
  bool checkbox = false;
  Color checkBoxBorder = AppColors.greyShade;
  Color genderContainerBorderMan = const Color(0xffE3E3E3);
  Color genderContainerMan = const Color(0xffF3F3F3);
  DateTime date = DateTime(2016, 10, 26);
  String? SelectedPackage;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;
  @override
  void initState() {
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
          title: Image.asset(
            hLogo,
            width: 105.w,
            height: 18.h,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ProgressHUD(
            inAsyncCall: loading,
            opacity: 0.1,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, "How much would you pay for an adventure?",
                      24.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w600,
                      fontFamily: "Poppins-SemiBold"),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SelectedPackage = "week";
                          if (mounted) {
                            setState(() {
                              loading = true;
                            });
                          }
                          AppRoutes.push(context, PageTransitionType.fade,
                              const CreateProfile());
                          // const paymentItems = [
                          //   PaymentItem(
                          //     label: 'ONE WEEK PACKAGE',
                          //     amount: '9.99',
                          //     status: PaymentItemStatus.final_price,
                          //   )
                          // ];
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return Dialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         elevation: 0.0,
                          //         backgroundColor: Colors.transparent,
                          //         child: Container(
                          //           width: 515.w,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(14.r),
                          //           ),
                          //           child: SingleChildScrollView(
                          //             child: Column(
                          //               children: [
                          //                 Container(
                          //                   padding: const EdgeInsets.only(
                          //                       left: 8.0,
                          //                       right: 8.0,
                          //                       top: 5.0,
                          //                       bottom: 5.0),
                          //                   width: 515.w,
                          //                   decoration: BoxDecoration(
                          //                     color: AppColors.redcolor,
                          //                     borderRadius: BorderRadius.only(
                          //                         topLeft:
                          //                             Radius.circular(14.r),
                          //                         topRight:
                          //                             Radius.circular(14.r)),
                          //                   ),
                          //                   child: Align(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       "Action Required",
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.w600,
                          //                           color: Colors.white,
                          //                           fontFamily:
                          //                               'Poppins-Medium',
                          //                           fontSize: 22.sp),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 SizedBox(height: 10.h),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.center,
                          //                   children: [
                          //                     Container(
                          //                         width: 50.w,
                          //                         height: 50.h,
                          //                         decoration:
                          //                             const BoxDecoration(
                          //                           shape: BoxShape.circle,
                          //                           color: AppColors.redcolor,
                          //                         ),
                          //                         child: Image.asset(icon)),
                          //                     SizedBox(
                          //                       width: 20.w,
                          //                     ),
                          //                     Text(
                          //                       "Confirm",
                          //                       style: TextStyle(
                          //                           fontWeight: FontWeight.bold,
                          //                           color: Colors.black,
                          //                           fontFamily:
                          //                               'Poppins-Medium',
                          //                           fontSize: 20.sp),
                          //                     )
                          //                   ],
                          //                 ),
                          //                 SizedBox(height: 10.h),
                          //                 Text(
                          //                   "One week package \$9.99",
                          //                   style: TextStyle(
                          //                       fontWeight: FontWeight.w300,
                          //                       color: Colors.black,
                          //                       fontFamily: 'Poppins-Regular',
                          //                       fontSize: 18.sp),
                          //                   textAlign: TextAlign.center,
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10.h,
                          //                 ),
                          //                 Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.center,
                          //                   children: [
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                       children: [
                          //                         ApplePayButton(
                          //                           width: 200,
                          //                           height: 50,
                          //                           paymentConfigurationAsset:
                          //                               'files/applepay.json',
                          //                           paymentItems: paymentItems,
                          //                           style: ApplePayButtonStyle
                          //                               .black,
                          //                           type:
                          //                               ApplePayButtonType.buy,
                          //                           margin:
                          //                               const EdgeInsets.only(
                          //                                   top: 15.0),
                          //                           onPaymentResult: (data) {
                          //                             print(data);
                          //                             postDetailsToFirestore(
                          //                                 context,
                          //                                 SelectedPackage);
                          //                           },
                          //                           loadingIndicator:
                          //                               const Center(
                          //                             child:
                          //                                 CircularProgressIndicator(),
                          //                           ),
                          //                         ),
                          //                         GooglePayButton(
                          //                           width: 200,
                          //                           height: 50,
                          //                           paymentConfigurationAsset:
                          //                               'files/gpay.json',
                          //                           paymentItems: paymentItems,
                          //                           style: GooglePayButtonStyle
                          //                               .black,
                          //                           type:
                          //                               GooglePayButtonType.pay,
                          //                           margin:
                          //                               const EdgeInsets.only(
                          //                                   top: 15.0),
                          //                           onPaymentResult: (data) {
                          //                             print(data);
                          //                             postDetailsToFirestore(
                          //                                 context,
                          //                                 SelectedPackage);
                          //                           },
                          //                           loadingIndicator:
                          //                               const Center(
                          //                             child:
                          //                                 CircularProgressIndicator(),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 SizedBox(height: 20.h)
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     });
                        },
                        child: Container(
                          height: 190.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(week), fit: BoxFit.fill)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              text(context, "ONE WEEK", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Regular"),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(context, "\$9.99", 14.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Bold"),
                            ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          SelectedPackage = "month";
                          if (mounted) {
                            setState(() {
                              loading = true;
                            });
                          }

                          const paymentItems = [
                            PaymentItem(
                              label: 'ONE MONTH PACKAGE',
                              amount: '29.99',
                              status: PaymentItemStatus.final_price,
                            )
                          ];
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: 515.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            width: 515.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.redcolor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(14.r),
                                                  topRight:
                                                      Radius.circular(14.r)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Action Required",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 22.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.redcolor,
                                                  ),
                                                  child: Image.asset(icon)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 20.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "One Month package \$29.99",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 18.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ApplePayButton(
                                                    width: 200,
                                                    height: 50,
                                                    paymentConfigurationAsset:
                                                        'files/applepay.json',
                                                    paymentItems: paymentItems,
                                                    style: ApplePayButtonStyle
                                                        .black,
                                                    type:
                                                        ApplePayButtonType.buy,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    onPaymentResult: (data) {
                                                      print(data);
                                                      postDetailsToFirestore(
                                                          context,
                                                          SelectedPackage);
                                                    },
                                                    loadingIndicator:
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  GooglePayButton(
                                                    width: 200,
                                                    height: 50,
                                                    paymentConfigurationAsset:
                                                        'files/gpay.json',
                                                    paymentItems: paymentItems,
                                                    style: GooglePayButtonStyle
                                                        .black,
                                                    type:
                                                        GooglePayButtonType.pay,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    onPaymentResult: (data) {
                                                      print(data);
                                                      postDetailsToFirestore(
                                                          context,
                                                          SelectedPackage);
                                                    },
                                                    loadingIndicator:
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          height: 190.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(month), fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              text(context, "ONE MONTH", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Regular"),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(context, "\$29.99", 14.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Bold"),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(context, "SAVE  \$10", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Regular"),
                            ]),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          SelectedPackage = "year";
                          if (mounted) {
                            setState(() {
                              loading = true;
                            });
                          }
                          const paymentItems = [
                            PaymentItem(
                              label: 'ONE WEEK PACKAGE',
                              amount: '299.99',
                              status: PaymentItemStatus.final_price,
                            )
                          ];
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: 515.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            width: 515.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.redcolor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(14.r),
                                                  topRight:
                                                      Radius.circular(14.r)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Action Required",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 22.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.redcolor,
                                                  ),
                                                  child: Image.asset(icon)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    fontSize: 20.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "One Year package \$299.99",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontFamily: 'Poppins-Regular',
                                                fontSize: 18.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ApplePayButton(
                                                    width: 200,
                                                    height: 50,
                                                    paymentConfigurationAsset:
                                                        'files/applepay.json',
                                                    paymentItems: paymentItems,
                                                    style: ApplePayButtonStyle
                                                        .black,
                                                    type:
                                                        ApplePayButtonType.buy,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    onPaymentResult: (data) {
                                                      print(data);
                                                      postDetailsToFirestore(
                                                          context,
                                                          SelectedPackage);
                                                    },
                                                    loadingIndicator:
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  GooglePayButton(
                                                    width: 200,
                                                    height: 50,
                                                    paymentConfigurationAsset:
                                                        'files/gpay.json',
                                                    paymentItems: paymentItems,
                                                    style: GooglePayButtonStyle
                                                        .black,
                                                    type:
                                                        GooglePayButtonType.pay,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    onPaymentResult: (data) {
                                                      print(data);
                                                      postDetailsToFirestore(
                                                          context,
                                                          SelectedPackage);
                                                    },
                                                    loadingIndicator:
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          height: 190.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(year), fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              text(context, "ONE YEAR", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Regular"),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(context, "\$299.99", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Bold"),
                              SizedBox(
                                height: 10.h,
                              ),
                              text(context, "SAVE  \$20", 12.sp,
                                  color: AppColors.white,
                                  boldText: FontWeight.w400,
                                  fontFamily: "Roboto-Regular"),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  text(
                      context,
                      "After purchasing the subscription, your post will appear to the public. You can also see posts from other people. Find someone you like and Have fun!",
                      14.sp,
                      color: const Color(0xff9C9C9C),
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(
                      context,
                      "You can like anyone around the world. CRAVE has no borders! Tap on the ♥ icon, go chatting and have fun!",
                      14.sp,
                      color: const Color(0xff9C9C9C),
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(
                      context,
                      "All chats self-destruct in 24 hours.If you want to add more time to the chat timer, it's only \$1.99",
                      14.sp,
                      color: const Color(0xff9C9C9C),
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(
                      context,
                      "Try Video Chatting with someone new, tap the 🎥 icon in Chat and get to know someone through the lens of your camera! ",
                      14.sp,
                      color: const Color(0xff9C9C9C),
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Regular"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text(context, "Privacy Policy ", 12.sp,
                                color: const Color(0xffAAAAAA),
                                boldText: FontWeight.w400,
                                fontFamily: "Poppins-Medium"),
                            SizedBox(width: 5.w),
                            Container(
                              height: 12.h,
                              width: 2.w,
                              color: const Color(0xFF565656),
                            ),
                            SizedBox(width: 5.w),
                            text(context, "Terms of Service", 12.sp,
                                color: const Color(0xffAAAAAA),
                                boldText: FontWeight.w400,
                                fontFamily: "Poppins-Medium"),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void postDetailsToFirestore(BuildContext context, package) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'package': package,
      'steps': '5',
    }).then((text) {
      if (mounted) {
        ToastUtils.showCustomToast(context, "Package Added", Colors.green);
        setState(() {
          loading = false;
        });
        preferences.setString("package", package);
        AppRoutes.push(context, PageTransitionType.fade, const CreateProfile());
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
