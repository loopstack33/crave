import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/messageModel.dart';

class FavoriteContacts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Text(
                'Likes You',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  color: AppColors.black,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.redcolor
                ),
                padding:const EdgeInsets.only(left: 3,right: 3,top: 2,bottom: 2),
                margin:const EdgeInsets.all(2),
                child: Text("12",style: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins-SemiBold',color: AppColors.white),),
              )
            ],
          ),
        ),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            shrinkWrap: true,
            padding:const EdgeInsets.only(left: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => {},
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30.r,
                        backgroundImage:
                        AssetImage(favorites[index].imageUrl),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        favorites[index].name,
                        style:  TextStyle(
                          color: AppColors.black,
                          fontFamily: 'Poppins-Medium',
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}