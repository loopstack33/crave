// ignore_for_file: file_names

import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/chat_users.dart';
import '../../../../widgets/conversationList.dart';
import 'favoriteChat.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Adria Thomas", messageText: "Are you here for hookup?", imageURL: "assets/images/5.png", time: "12:10 AM",count: "1"),
    ChatUsers(name: "Victoria Griffin", messageText: "Come on, I don’t mind!", imageURL: "assets/images/4.png", time: "10:15 pm",count: "3"),
    ChatUsers(name: "Daria Sanchez", messageText: "It would be a great idea!", imageURL: "assets/images/1.png", time: "2:30 pm",count: "0"),
    ChatUsers(name: "Eva Jenkins", messageText: "Yes, I love cooking", imageURL: "assets/images/2.png", time: "1:10 pm",count: "0"),
    ChatUsers(name: "Isabella Lopez", messageText: "I go to gym 3 times a week.", imageURL: "assets/images/3.png", time: "2 days",count: "0"),
  ];

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
                 FavoriteContacts(),
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
                ListView.builder(
                  itemCount: chatUsers.length,
                  shrinkWrap: true,
                  padding:const EdgeInsets.only(top: 10),
                  physics:const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return ConversationList(
                      count:chatUsers[index].count,
                      name: chatUsers[index].name,
                      messageText: chatUsers[index].messageText,
                      imageUrl: chatUsers[index].imageURL,
                      time: chatUsers[index].time,
                      isMessageRead: (index == 0 || index == 1)?true:false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
