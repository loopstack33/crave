import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final textController = TextEditingController();
  int charLength = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    _onChanged(String value) {
      setState(() {
        charLength = value.length;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
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
        title: text(context, "Create Profile", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
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
                Image.asset(
                  addpic,
                  width: 102.w,
                  height: 154.h,
                ),
                Image.asset(
                  addpic,
                  width: 102.w,
                  height: 154.h,
                ),
                Image.asset(
                  addpic,
                  width: 102.w,
                  height: 154.h,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            text(context, "About Me", 16.sp,
                color: const Color(0xff191919),
                boldText: FontWeight.w500,
                fontFamily: "Roboto-Medium"),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 136.h,
              // margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  onSaved: (String? value) {
                    textController.text = value!;
                  },
                  style: const TextStyle(
                      fontFamily: "Poppins-Regular",
                      fontSize: 14,
                      color: Color(0xff636363)),
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  controller: textController,
                  autocorrect: true,
                  decoration: InputDecoration(
                    counterText: charLength.toString(),
                    counterStyle:
                        TextStyle(fontFamily: "Poppins-Regular", fontSize: 12),
                    hintText: 'Enter Some Text',
                    hintStyle: const TextStyle(
                        fontFamily: "Poppins-Regular", fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onChanged: _onChanged,
                ),
              ),
            ),
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
            //chipping
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.redcolor,
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
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.redcolor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            casualDating1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "No String Attached", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            nostring,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "In Person", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            inperson1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Sexting", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            sexting,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Kinky", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            kinky1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Vanilla", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            vanilla1,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Submissive", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            submissive1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: AppColors.redcolor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Dominance", 12.sp,
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
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            vanilla1,
                            color: Colors.white,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Dress Up", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            dressup1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Blindfolding", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            blindfolding1,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Bondage", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            bondage1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Butt Stuff", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            buttstuf1,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Roleplay", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            roleplay1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Feet Stuff", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            feetstuf1,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Golden Showers", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            shower1,
                            width: 8.w,
                            height: 10.h,
                          ),
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
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Dirty Talk", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 22,
                          width: 22,
                          decoration: const BoxDecoration(
                            //  color: Color(0xff545454),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            dirtytalk1,
                            width: 12.w,
                            height: 16.h,
                          ),
                        ),
                      ],
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
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(context, "Cuddling", 12.sp,
                            color: AppColors.black,
                            boldText: FontWeight.w400,
                            fontFamily: "Poppins-Regular"),
                        SizedBox(
                          width: 5.h,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            cuddling1,
                            width: 8.w,
                            height: 10.h,
                          ),
                        ),
                      ],
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
                  if (textController.text.isNotEmpty) {
                    // postDetailsToFirestore(context, textController.text);
                    print("ok");
                  }
                }),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      )),
    );
  }

  void postDetailsToFirestore(BuildContext context, bio) async {
    final auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'bio': bio,
    }).then((text) {
      if (mounted) {
        ToastUtils.showCustomToast(context, "bio Added", Colors.green);
        setState(() {
          loading = false;
        });
        preferences.setString("bio", bio);
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
