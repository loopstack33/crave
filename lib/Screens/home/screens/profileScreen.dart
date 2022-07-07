// ignore_for_file: file_names

import 'package:crave/Screens/home/screens/editProfile.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            AppRoutes.push(context, PageTransitionType.fade, EditProfile());
          },
          child: text(context, "edit profile", 15.sp,
              color: AppColors.redcolor, fontFamily: 'Poppins-Regular'),
        ),
      ),
    );
  }
}
