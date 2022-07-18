// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/profile/mycraves.dart';
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controllerBio = TextEditingController();
  bool clearPic1 = true;
  bool clearPic = true;
  bool clearPic2 = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String id = '';
  List<dynamic> photoUrl = [];
  List<dynamic> craves = [];
  String name = 'Name';
  String age = 'Age';
  String country = 'Country';
  String bio = 'Bio';
  String pic1url = "";
  String pic2url = "";
  String pic3url = "";
  bool isLoading = true;
  File? avatarImageFile;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        id = value.data()!["uid"];
        photoUrl = value.data()!["imageUrl"];
        craves = value.data()!["craves"];
        name = value.data()!["name"];
        bio = value.data()!["bio"];
        country = value.data()!["country"];
        age = value.data()!["age"];
        isLoading = false;
        pic1url = photoUrl[0];
        if (photoUrl.length == 2) {
          pic2url = photoUrl[1];
        }
        if (photoUrl.length == 3) {
          pic3url = photoUrl[2];
        }

        print(pic2url);
      });
      controllerBio = TextEditingController(text: bio);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.white,
        title: text(context, "Profile", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: ProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, "Profile Images", 16.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Roboto-Medium"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
//                           ClipRRect(
//     borderRadius: BorderRadius.circular(8.0),
//     child: Image.network(
//         ,
//         height: 150.0,
//         width: 100.0,
//     ),
// )
                          Container(
                            width: 102.w,
                            height: 154.h,
                            child: InkWell(
                                onTap: () {
                                  // imagePickermethod(1);
                                },
                                child: pic1url.isEmpty || clearPic == false
                                    ? Image.asset(addpic)
                                    : Image.network(pic1url)),
                          ),
                          if (clearPic == true) ...[
                            Positioned(
                              left: 65,
                              child: InkWell(
                                onTap: () {
                                  // setState(() {
                                  //   clearPic = false;
                                  // });
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    deletePic,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                      // Stack(
                      //   children: [
                      //     SizedBox(
                      //       width: 102.w,
                      //       height: 154.h,
                      //       child: InkWell(
                      //         onTap: () {
                      //           imagePickermethod(2);
                      //         },
                      //         child: _image1 == null || clearPic1 == false
                      //             ? Image.asset(addpic)
                      //             : Image.file(_image1!),
                      //       ),
                      //     ),
                      //     if (clearPic1 == true) ...[
                      //       Positioned(
                      //         left: 65,
                      //         child: InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               clearPic1 = false;
                      //             });
                      //           },
                      //           child: Align(
                      //             alignment: Alignment.topRight,
                      //             child: Image.asset(
                      //               deletePic,
                      //               width: 30.w,
                      //               height: 30.h,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     ]
                      //   ],
                      // ),
                      
                      // Stack(
                      //   children: [
                      //     SizedBox(
                      //       width: 102.w,
                      //       height: 154.h,
                      //       child: InkWell(
                      //         onTap: () {
                      //           imagePickermethod(3);
                      //         },
                      //         child: _image2 == null || clearPic2 == false
                      //             ? Image.asset(addpic)
                      //             : Image.file(_image2!),
                      //       ),
                      //     ),
                      //     if (clearPic2 == true) ...[
                      //       Positioned(
                      //         left: 65,
                      //         child: InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               clearPic2 = false;
                      //             });
                      //           },
                      //           child: Align(
                      //             alignment: Alignment.topRight,
                      //             child: Image.asset(
                      //               deletePic,
                      //               width: 30.w,
                      //               height: 30.h,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     ]
                      //   ],
                      // ),
                   
                   
                    ],
                  ),

                  //
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(context, "$name, $age", 28.sp,
                          color: const Color(0xff606060),
                          boldText: FontWeight.w500,
                          fontFamily: "Poppins-SemiBold"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        locationicon,
                        width: 16.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 5.w),
                      text(context, country, 14.sp,
                          color: const Color(0xff606060),
                          boldText: FontWeight.w500,
                          fontFamily: "Poppins-Medium"),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(context, "ABOUT ME", 16.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Poppins-SemiBold"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    // height: 136.h,

                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff636363),
                              fontFamily: "Poppins-Regular"),
                          controller: controllerBio,
                          maxLines: 2,
                          maxLength: 100,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 0, bottom: 5, top: 5, right: 5),
                              hintText: "About Me",
                              hintStyle: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 14.sp,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400)),
                        )),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 335.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                mycraves,
                                width: 114.w,
                                height: 22.h,
                              ),
                              InkWell(
                                onTap: () {
                                  AppRoutes.push(
                                      context,
                                      PageTransitionType.fade,
                                      const MyCraves());
                                },
                                child: Container(
                                  height: 35.h,
                                  width: 85.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.redcolor,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      text(context, "Add", 16.sp,
                                          color: AppColors.white,
                                          boldText: FontWeight.w400,
                                          fontFamily: "Poppins-Regular"),
                                      const Icon(
                                        Icons.add,
                                        color: AppColors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 4.0, // gap between lines
                              children: craves
                                  .map((e) => Chip(
                                        labelPadding: const EdgeInsets.all(2.0),
                                        avatar: CircleAvatar(
                                          backgroundColor: AppColors.chipColor,
                                          child: Image.asset(
                                            e == "Casual Dating"
                                                ? casualdating
                                                : e == "No String Attached"
                                                    ? nostring1
                                                    : e == "In Person"
                                                        ? inperson
                                                        : e == "Sexting"
                                                            ? sexting2
                                                            : e == "Kinky"
                                                                ? kinky
                                                                : e == "Vanilla"
                                                                    ? vanilla
                                                                    : e == "Submissive"
                                                                        ? submissive
                                                                        : e == "Dominance"
                                                                            ? dominance
                                                                            : e == "Dress Up"
                                                                                ? dressup
                                                                                : e == "Blindfolding"
                                                                                    ? blindfolding
                                                                                    : e == "Bondage"
                                                                                        ? bondage
                                                                                        : e == "Butt Stuff"
                                                                                            ? buttstuff
                                                                                            : kinky1,
                                            color: AppColors.white,
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                        label: Text(
                                          e.toString(),
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppColors.white,
                                              fontFamily: "Poppins-Regular"),
                                        ),
                                        deleteIcon: Image.asset(
                                          cross,
                                          width: 19.w,
                                          height: 19.h,
                                        ),
                                        onDeleted: () {},
                                        backgroundColor: AppColors.chipCircle,
                                        padding: const EdgeInsets.all(6.0),
                                      ))
                                  .toList(),
                            ),
                          ),
                          /*Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "Kinky", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          kinky,
                                          width: 14.w,
                                          height: 16.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "Casual Dating", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        casualdating,
                                        width: 12.w,
                                        height: 16.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "Submissive", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          submissive,
                                          width: 14.w,
                                          height: 16.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "In Person", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        inperson,
                                        width: 12.w,
                                        height: 16.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "Dirty Talk", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          dirtytalk,
                                          width: 14.w,
                                          height: 16.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff464646),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    text(context, "Vanilla", 12.sp,
                                        color: AppColors.white,
                                        boldText: FontWeight.w400,
                                        fontFamily: "Poppins-Regular"),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 22,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff545454),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        vanilla,
                                        width: 12.w,
                                        height: 16.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Image.asset(
                                      cross,
                                      width: 19.w,
                                      height: 19.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),*/
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(context, "Disable Account", 20.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w400,
                      fontFamily: "Poppins-Medium"),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
