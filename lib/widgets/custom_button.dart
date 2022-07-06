// ignore_for_file: must_be_immutable

import 'package:crave/utils/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  String text;
  final Function() press;
  DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 320.w,
        height: 56.h,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.redcolor, width: 1),
            color: AppColors.redcolor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'Poppins-SemiBold',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
