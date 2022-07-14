// ignore_for_file: must_be_immutable

import 'package:crave/utils/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultButton extends StatelessWidget {
  String text;
  final Function() press;
  Color? color;
  DefaultButton({
    Key? key,
    this.color,
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
            border: Border.all(color:color ?? AppColors.redcolor, width: 1),
            color:color ?? AppColors.redcolor,
            borderRadius: BorderRadius.circular(8.r)),
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
