
// ignore_for_file: file_names

import 'package:crave/Screens/home/screens/chat/chatScreen.dart';
import 'package:crave/Screens/home/screens/dashboardScreen.dart';
import 'package:crave/Screens/home/screens/matchedScreens/matchScreen.dart';
import 'package:crave/Screens/home/screens/profile/profileScreen.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final screens = [
    const Dashboard(),
    const MatchScreen(),
    const Chat(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: AppColors.white,
            primaryColor: AppColors.white,
          ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:_selectedIndex==0 ?Image.asset(i1,width: 30.w,height: 30.h,):Image.asset(i_1,width: 30.w,height: 30.h,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:_selectedIndex==1 ?Image.asset(i2,width: 30.w,height: 30.h,):Image.asset(i_2,width: 30.w,height: 30.h,),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon:_selectedIndex==2 ?Image.asset(i3,width: 30.w,height: 30.h,):Image.asset(i_3,width: 30.w,height: 30.h,),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon:_selectedIndex==3 ?Image.asset(i4,width: 30.w,height: 30.h,):Image.asset(i_4,width: 30.w,height: 30.h,),
              label: 'School',
            ),
          ],
          currentIndex: _selectedIndex,

          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
