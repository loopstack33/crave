// ignore_for_file: must_be_immutable
import 'package:crave/utils/color_constant.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultIconButton extends StatelessWidget {
  String text;
  final Function() press;
  String fontFamily;
  double size;
  Color iconColor;
  IconData icon;
  FontWeight weight;
  Color color;
  DefaultIconButton({
    Key? key,
    required this.iconColor,
    required this.icon,
    required this.weight,
    required this.color,
    required this.fontFamily,
    required this.text,
    required this.press,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
          width: 320.w,
          height: 56.h,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               FaIcon(
                icon,
                color: iconColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(
                  color:color,
                  fontSize: size,
                  fontWeight: weight,
                  fontFamily: fontFamily,
                ),
              )
            ],
          )),
    );
  }
}
