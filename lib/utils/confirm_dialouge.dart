import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ConfirmDialog extends StatefulWidget {
  String message;

  final Function() press;
  ConfirmDialog({Key? key, required this.message, required this.press})
      : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  Color dTextColorRed = AppColors.redcolor;
  dialogContent(BuildContext context) {
    return Container(
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
                  left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
              width: 515.w,
              decoration: BoxDecoration(
                color: dTextColorRed,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r)),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Action Required",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins-Medium',
                      fontSize: 22.sp),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dTextColorRed,
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
                      fontFamily: 'Poppins-Medium',
                      fontSize: 20.sp),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              widget.message,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33000000),
                            blurRadius: 25.r,
                            spreadRadius: 5.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: Colors.white),
                    child: Center(
                        child: Text(
                      "No",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: dTextColorRed,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins-Medium'),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 100.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x33000000),
                          blurRadius: 25.r,
                          spreadRadius: 5.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.center,
                        colors: [Colors.white, dTextColorRed],
                      ),
                    ),
                    child: Center(
                        child: Text(
                      "Pay",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontFamily: 'Poppins-Medium'),
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
