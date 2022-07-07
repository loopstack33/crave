// ignore_for_file: file_names
import 'dart:ui';
import 'package:crave/Screens/home/screens/settings.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> imgList = [
    'https://source.unsplash.com/random/1920x1920/?abstracts',
    'https://source.unsplash.com/random/1920x1920/?fruits,flowers',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
              onTap: () {
                AppRoutes.push(
                    context, PageTransitionType.leftToRight, SettingsScreen());
              },
              child: Image.asset(menu)),
        ),
        title: Image.asset(
          hLogo,
          width: 105.w,
          height: 18.h,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              bell,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      FlutterCarousel(
                        options: CarouselOptions(
                          autoPlay: false,
                        ),
                        items: imgList
                            .map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.r)),
                                    child: Image.network(
                                      item,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (
                                        BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace,
                                      ) {
                                        return Text(
                                          'Oops!! An error occurred. 😢',
                                          style: TextStyle(fontSize: 16.sp),
                                        );
                                      },
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      /* ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset("assets/images/bibi.jpg",)),*/
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    location,
                                    width: 15.w,
                                    height: 15.h,
                                  ),
                                  SizedBox(width: 5.w),
                                  text(context, "Los Angels", 15.sp,
                                      color: AppColors.white,
                                      fontFamily: 'Poppins-Regular'),
                                ],
                              ),
                              Text.rich(
                                textAlign: TextAlign.end,
                                TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: '5 miI, Online\n',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: 15.sp),
                                  ),
                                  TextSpan(
                                    text: ' Active',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: 15.sp),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        ),
                      )),
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              text(context, "Adria Thomas", 22.sp,
                                  color: AppColors.white,
                                  fontFamily: 'Poppins-Medium'),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        color: AppColors.containerborder
                                            .withOpacity(0.6),
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.circleInfo,
                                              size: 28.sp,
                                              color: AppColors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        color: AppColors.containerborder
                                            .withOpacity(0.6),
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.commentDots,
                                              size: 28.sp,
                                              color: AppColors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        color: AppColors.containerborder
                                            .withOpacity(0.6),
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: Icon(
                                              FontAwesomeIcons.solidHeart,
                                              size: 28.sp,
                                              color: AppColors.white,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  text(
                      context,
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lacus, feugiat bibendum mus viverra augue scelerisque. Faucibus montes.",
                      12.sp,
                      color: AppColors.white,
                      fontFamily: 'Poppins-Regular')
                ],
              ),
            );
          },
          itemCount: 3,
        ),
      ),
    );
  }
}
