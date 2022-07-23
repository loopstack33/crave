// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:crave/Screens/home/screens/chat/widgets/chatListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/color_constant.dart';
import 'favoriteChat.dart';


class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  State<UserChatList> createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {


  bool loading = true;
  bool dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const FavoriteContacts(),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0),
                  child: Divider(color: AppColors.containerborder,thickness: 1.w,),
                ),
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Messages',
                        style: TextStyle(
                          fontFamily: 'Poppins-Medium',
                          color: AppColors.black,
                          fontSize: 22.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const ChatListWidget(),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

