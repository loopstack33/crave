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
  late GlobalKey<ScaffoldState> _key;
  late List<Company> _companies;
  late List<String> _filters;
  int craveCounter = 0;
  final textController = TextEditingController();
  int charLength = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _companies = <Company>[
      Company('Casual Dating', false, casualdating),
      Company('No String Attached', false, nostring),
      Company('In Person', false, inperson1),
      Company('Sexting', false, sexting),
      Company('Kinky', false, kinky1),
      Company('Vanilla', false, vanilla1),
      Company('Submissive', false, submissive),
      Company('Dominance', false, dominance),
      Company('Dress Up', false, dressup1),
      Company('Blindfolding', false, blindfolding1),
      Company('Bondage', false, bondage1),
      Company('Roleplay', false, roleplay1),
      Company('Feet Stuff', false, feetstuf1),
      Company('Golden Showers', false, shower1),
      Company('Dirty Talk', false, dirtytalk1),
      Company('Cuddling', false, cuddling1)
    ];
  }

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
                  maxLength: 200,
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
              child: text(context, "Selected  ${craveCounter}/3", 14.sp,
                  color: AppColors.black,
                  boldText: FontWeight.w400,
                  fontFamily: "Poppins-Medium"),
            ),
            SizedBox(
              height: 10.h,
            ),
            //chipping
            Column(
              children: <Widget>[
                Wrap(
                  children: companyWidgets.toList(),
                ),
                Text('Selected: ${_filters.join(', ')}'),
              ],
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

  Iterable<Widget> get companyWidgets sync* {
    for (Company company in _companies) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          showCheckmark: false,
          avatar: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  Color(0xffFF6767),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              company.iconname,
              color:
                  company.status == false ? AppColors.redcolor : Colors.white,
              width: 8.w,
              height: 9.h,
              fit: BoxFit.cover,
            ),
          ),
          backgroundColor:
              company.status == false ? Color(0xffFAFAFA) : AppColors.redcolor,
          label: text(context, company.name, 12.sp,
              color: company.status == false ? Colors.black : AppColors.white,
              boldText: FontWeight.w400,
              fontFamily: "Poppins-Regular"),
          selected: _filters.contains(company.name),
          selectedColor:
              company.status == false ? Colors.white : AppColors.redcolor,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                if (_filters.length < 3) {
                  craveCounter = _filters.length + 1;
                  _filters.add(company.name);
                  company.status = true;
                } else {
                  // ToastUtils.showCustomToast(
                  //     context, "limit exceeded", Colors.green);
                }
              } else {
                company.status = false;

                _filters.removeWhere((String name) {
                  return name == company.name;
                });
                craveCounter--;
              }

              if (_filters.length < 3) {
              } else {
                ToastUtils.showCustomToast(
                    context, "limit acheived", Colors.green);
              }
            });
          },
        ),
      );
    }
  }
}

class Company {
  Company(this.name, this.status, this.iconname);
  final String name;
  bool status;
  final String iconname;
}
