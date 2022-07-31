import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCraves extends StatefulWidget {
  const MyCraves({Key? key}) : super(key: key);

  @override
  State<MyCraves> createState() => _MyCravesState();
}

class _MyCravesState extends State<MyCraves> {
  String? uid;
  late List<String> _filters;
  late List<String> _selected;
  //bool check
  bool? casualDatingcheck = false;
  bool? noStringAttached = false;
  bool? inPerson = false;
  bool? Sextingcheck = false;
  bool? kinkycheck = false;
  bool? vanillacheck = false;
  bool? submissivecheck = false;
  bool? dominancecheck = false;
  bool? dressupCheck = false;
  bool? blindfoldingCheck = false;
  bool? bondageCheck = false;
  bool? buttstuffCheck = false;
  bool? rolePlayCheck = false;
  bool? FeetStufcheck = false;
  bool? goldenShowercheck = false;
  bool? dirtyTalkCheck = false;
  bool? cuddlingCheck = false;
  //alreadyliked craves check
  bool? casualDatingcheckalready = false;
  bool? noStringAttachedalready = false;
  bool? inPersonalready = false;
  bool? Sextingcheckalready = false;
  bool? kinkycheckalready = false;
  bool? vanillacheckalready = false;
  bool? submissivecheckalready = false;
  bool? dominancecheckalready = false;
  bool? dressupCheckalready = false;
  bool? blindfoldingCheckalready = false;
  bool? bondageCheckalready = false;
  bool? buttstuffCheckalready = false;
  bool? rolePlayCheckalready = false;
  bool? FeetStufcheckalready = false;
  bool? goldenShowercheckalready = false;
  bool? dirtyTalkCheckalready = false;
  bool? cuddlingCheckalready = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filters = <String>[];
    _selected = <String>[];
    uid = _auth.currentUser!.uid;
    addcraves();
  }

  List<dynamic> craves = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addcraves() async {
    await _firestore.collection('users').doc(uid).get().then((value) {
      //
      setState(() {
        craves = value.data()!["craves"];
      });
    });
    addtofilters();
  }

  addtofilters() {
    log(craves.toString());
    setState(() {
      for (int i = 0; i < craves.length; i++) {
        _filters.add(craves[i]);
      }
      // isLoad = false;
      log("this=> $_filters");
      if (_filters.contains("Casual Dating")) {
        casualDatingcheck = true;
        casualDatingcheckalready = true;
      }
      if (_filters.contains("No String Attached")) {
        noStringAttached = true;
        noStringAttachedalready = true;
      }
      if (_filters.contains("In Person")) {
        inPerson = true;
        inPersonalready = true;
      }
      if (_filters.contains("Sexting")) {
        Sextingcheck = true;
        Sextingcheckalready = true;
      }
      if (_filters.contains("Kinky")) {
        kinkycheck = true;
        kinkycheckalready = true;
      }
      if (_filters.contains("Vanilla")) {
        vanillacheck = true;
        vanillacheckalready = true;
      }
      if (_filters.contains("Submissive")) {
        submissivecheck = true;
        submissivecheckalready = true;
      }
      if (_filters.contains("Dominance")) {
        dominancecheck = true;
        dominancecheckalready = true;
      }
      if (_filters.contains("Dress Up")) {
        dressupCheck = true;
        dressupCheckalready = true;
      }
      if (_filters.contains("Blindfolding")) {
        blindfoldingCheck = true;
        blindfoldingCheckalready = true;
      }
      if (_filters.contains("Bondage")) {
        bondageCheck = true;
        bondageCheckalready = true;
      }
      if (_filters.contains("Butt Stuff")) {
        buttstuffCheck = true;
        buttstuffCheckalready = true;
      }
      if (_filters.contains("Roleplay")) {
        rolePlayCheck = true;
        rolePlayCheckalready = true;
      }
      if (_filters.contains("Feet Stuff")) {
        FeetStufcheck = true;
        FeetStufcheckalready = true;
      }
      if (_filters.contains("Golden Showers")) {
        goldenShowercheck = true;
        goldenShowercheckalready = true;
      }
      if (_filters.contains("Dirty Talk")) {
        dirtyTalkCheck = true;
        dirtyTalkCheckalready = true;
      }
      if (_filters.contains("Cuddling")) {
        cuddlingCheck = true;
        cuddlingCheckalready = true;
      }
    });
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
        title: text(context, "MY CRAVES", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            text(context, "Let Us Know What You’re Down for...", 24.sp,
                color: AppColors.black,
                boldText: FontWeight.w500,
                fontFamily: "Poppins-Medium"),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: text(context, "Selected  2/3", 14.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Medium"),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (casualDatingcheckalready == true) {
                    } else {
                      if (casualDatingcheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Casual Dating";
                          });
                          casualDatingcheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Casual Dating");
                          casualDatingcheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: casualDatingcheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Casual Dating", 12.sp,
                              color: casualDatingcheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: casualDatingcheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              casualDating1,
                              width: 8.w,
                              height: 10.h,
                              color: casualDatingcheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (noStringAttachedalready == true) {
                    } else {
                      if (noStringAttached == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "No String Attached";
                          });
                          noStringAttached = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("No String Attached");
                          noStringAttached = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: noStringAttached == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "No String Attached", 12.sp,
                              color: noStringAttached == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: noStringAttached == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              nostring,
                              width: 12.w,
                              height: 16.h,
                              color: noStringAttached == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (inPersonalready == true) {
                    } else {
                      if (inPerson == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "In Person";
                          });
                          inPerson = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("In Person");
                          inPerson = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: inPerson == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "In Person", 12.sp,
                              color: inPerson == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: inPerson == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              inperson1,
                              width: 8.w,
                              height: 10.h,
                              color:
                                  inPerson == true ? Colors.white : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (Sextingcheckalready == true) {
                    } else {
                      if (Sextingcheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Sexting";
                          });
                          Sextingcheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Sexting");
                          Sextingcheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Sextingcheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Sexting", 12.sp,
                              color: Sextingcheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: Sextingcheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              sexting,
                              width: 12.w,
                              height: 16.h,
                              color: Sextingcheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (kinkycheckalready == true) {
                    } else {
                      if (kinkycheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Kinky";
                          });
                          kinkycheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Kinky");
                          kinkycheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: kinkycheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Kinky", 12.sp,
                              color: kinkycheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: kinkycheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              kinky1,
                              width: 8.w,
                              height: 10.h,
                              color: kinkycheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (vanillacheckalready == true) {
                    } else {
                      if (vanillacheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Vanilla";
                          });
                          vanillacheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Vanilla");
                          vanillacheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: vanillacheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Vanilla", 12.sp,
                              color: vanillacheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: vanillacheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              vanilla1,
                              width: 12.w,
                              height: 16.h,
                              color: vanillacheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (submissivecheckalready == true) {
                    } else {
                      if (submissivecheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Submissive";
                          });
                          submissivecheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Submissive");
                          submissivecheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: submissivecheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Submissive", 12.sp,
                              color: submissivecheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: submissivecheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              submissive1,
                              width: 8.w,
                              height: 10.h,
                              color: submissivecheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (dominancecheckalready == true) {
                    } else {
                      if (dominancecheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Dominance";
                          });
                          dominancecheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Dominance");
                          dominancecheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: dominancecheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Dominance", 12.sp,
                              color: dominancecheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: dominancecheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              dominance1,
                              color: dominancecheck == true
                                  ? Colors.white
                                  : Colors.red,
                              width: 12.w,
                              height: 16.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (dressupCheckalready == true) {
                    } else {
                      if (dressupCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Dress Up";
                          });
                          dressupCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Dress Up");
                          dressupCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: dressupCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Dress Up", 12.sp,
                              color: dressupCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: dressupCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                            ),
                            child: Image.asset(
                              dressup1,
                              width: 8.w,
                              height: 10.h,
                              color: dressupCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (blindfoldingCheckalready == true) {
                    } else {
                      if (blindfoldingCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Blindfolding";
                          });
                          blindfoldingCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Blindfolding");
                          blindfoldingCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: blindfoldingCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Blindfolding", 12.sp,
                              color: blindfoldingCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: blindfoldingCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              blindfolding1,
                              width: 12.w,
                              height: 16.h,
                              color: blindfoldingCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (bondageCheckalready == true) {
                    } else {
                      if (bondageCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Bondage";
                          });
                          bondageCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Bondage");
                          bondageCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: bondageCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Bondage", 12.sp,
                              color: bondageCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bondageCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                            ),
                            child: Image.asset(
                              bondage1,
                              width: 8.w,
                              height: 10.h,
                              color: bondageCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (buttstuffCheckalready == true) {
                    } else {
                      if (buttstuffCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Butt Stuff";
                          });
                          buttstuffCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Butt Stuff");
                          buttstuffCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: buttstuffCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Butt Stuff", 12.sp,
                              color: buttstuffCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: buttstuffCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              buttstuf1,
                              width: 12.w,
                              height: 16.h,
                              color: buttstuffCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (rolePlayCheckalready == true) {
                    } else {
                      if (rolePlayCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Roleplay";
                          });
                          rolePlayCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Roleplay");
                          rolePlayCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: rolePlayCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Roleplay", 12.sp,
                              color: rolePlayCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: rolePlayCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              roleplay1,
                              width: 8.w,
                              height: 10.h,
                              color: rolePlayCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (FeetStufcheckalready == true) {
                    } else {
                      if (FeetStufcheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Feet Stuff";
                          });
                          FeetStufcheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Feet Stuff");
                          FeetStufcheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: FeetStufcheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Feet Stuff", 12.sp,
                              color: FeetStufcheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: FeetStufcheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              feetstuf1,
                              width: 12.w,
                              height: 16.h,
                              color: FeetStufcheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (goldenShowercheckalready == true) {
                    } else {
                      if (goldenShowercheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Golden Showers";
                          });
                          goldenShowercheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Golden Showers");
                          goldenShowercheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: goldenShowercheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Golden Showers", 12.sp,
                              color: goldenShowercheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: goldenShowercheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              shower1,
                              width: 8.w,
                              height: 10.h,
                              color: goldenShowercheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () {
                    if (dirtyTalkCheckalready == true) {
                    } else {
                      if (dirtyTalkCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Dirty Talk";
                          });
                          dirtyTalkCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Dirty Talk");
                          dirtyTalkCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: dirtyTalkCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Dirty Talk", 12.sp,
                              color: dirtyTalkCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: dirtyTalkCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              dirtytalk1,
                              width: 12.w,
                              height: 16.h,
                              color: dirtyTalkCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (cuddlingCheckalready == true) {
                    } else {
                      if (cuddlingCheck == true) {
                        setState(() {
                          _selected.removeWhere((String name) {
                            return name == "Cuddling";
                          });
                          cuddlingCheck = false;
                        });
                      } else {
                        setState(() {
                          _selected.add("Cuddling");
                          cuddlingCheck = true;
                        });
                      }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: cuddlingCheck == true
                          ? AppColors.redcolor
                          : const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text(context, "Cuddling", 12.sp,
                              color: cuddlingCheck == true
                                  ? const Color(0xffFAFAFA)
                                  : AppColors.black,
                              boldText: FontWeight.w400,
                              fontFamily: "Poppins-Regular"),
                          SizedBox(
                            width: 5.h,
                          ),
                          Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: cuddlingCheck == true
                                  ? AppColors.redcolor
                                  : const Color(0xffFAFAFA),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              cuddling1,
                              width: 8.w,
                              height: 10.h,
                              color: cuddlingCheck == true
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            DefaultButton(
                text: "Confirm",
                press: () {
                  if (_selected.isNotEmpty) {
                    updateCraves();
                  } else {
                    AppRoutes.pop(context);
                  }
                })
          ],
        ),
      ),
    );
  }

  updateCraves() async {
    final auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'craves': FieldValue.arrayUnion(_selected),
    }).then((text) {
      AppRoutes.pop(context);
    }).catchError((e) {});
  }
}
