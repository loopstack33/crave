// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:crave/Screens/home/screens/chat/widgets/chatListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../utils/app_routes.dart';
import '../../../../utils/color_constant.dart';
import '../../homeScreen.dart';
import 'favoriteChat.dart';


class UserChatList extends StatefulWidget {
  bool isDash;
  UserChatList({Key? key,required this.isDash}) : super(key: key);

  @override
  State<UserChatList> createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {


  bool loading = true;
  bool dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: widget.isDash?AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            AppRoutes.pushAndRemoveUntil(
                context, PageTransitionType.topToBottom, const HomeScreen());
          },
          child:const Icon(FontAwesomeIcons.chevronLeft,color: AppColors.redcolor,),
        ),
        title: Text("ChatRoom",style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 20.sp,color: AppColors.redcolor),),
        backgroundColor: AppColors.white,

        elevation: 0,

      ):null,
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

