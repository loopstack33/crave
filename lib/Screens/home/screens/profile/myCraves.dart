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
  late List<Company> _companies;
  late List<String> _filters;
  late List<String> picsList;
  int craveCounter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filters = <String>[];
    picsList = <String>[];
    _companies = <Company>[
      Company('Casual Dating', false, casualDating1),
      Company('No String Attached', false, nostring),
      Company('In Person', false, inperson1),
      Company('Sexting', false, sexting),
      Company('Kinky', false, kinky1),
      Company('Vanilla', false, vanilla1),
      Company('Submissive', false, submissive1),
      Company('Dominance', false, dominance1),
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
        child: SingleChildScrollView(
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
                child: text(context, "Selected  $craveCounter/3", 14.sp,
                    color: AppColors.black,
                    boldText: FontWeight.w400,
                    fontFamily: "Poppins-Medium"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Wrap(
                children: companyWidgets.toList(),
              ),
              SizedBox(
                height: 10.h,
              ),
              DefaultButton(
                  text: "Confirm",
                  press: () {
                    updateCraves();
                  }),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateCraves() async {
    final auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'craves': FieldValue.arrayUnion(_filters),
    }).then((text) {
      AppRoutes.pop(context);
    }).catchError((e) {});
  }

  Iterable<Widget> get companyWidgets sync* {
    for (Company company in _companies) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          showCheckmark: false,
          avatar: Container(
            height: 40,
            width: 40,
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
              fit: BoxFit.contain,
            ),
          ),
          backgroundColor: company.status == false
              ? const Color(0xffFAFAFA)
              : AppColors.redcolor,
          label: text(context, company.name, 16.sp,
              color: company.status == false ? Colors.black : AppColors.white,
              boldText: FontWeight.w400,
              fontFamily: "Poppins-Regular"),
          selected: _filters.contains(company.name),
          selectedColor:
              company.status == false ? Colors.white : AppColors.redcolor,
          onSelected: (bool selected) {
            if (mounted) {
              setState(() {
                if (selected) {
                  if (_filters.length < 3) {
                    craveCounter = _filters.length + 1;
                    _filters.add(company.name);
                    company.status = true;
                  } else {}
                } else {
                  company.status = false;

                  _filters.removeWhere((String name) {
                    return name == company.name;
                  });
                  craveCounter--;
                }

                if (_filters.length < 3) {
                } else {}
              });
            }
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
