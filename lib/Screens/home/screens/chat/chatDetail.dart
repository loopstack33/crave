// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../model/chatMessage.dart';
import '../../../../utils/color_constant.dart';
import '../../../../utils/images.dart';

class ChatDetailPage extends StatefulWidget{
  String name, image;
  ChatDetailPage({Key? key, required this.name,required this.image}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "assets/images/message1.png", messageType: "receiver",type: "image",seen: "true"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver",type: "text",seen: "true"),
    ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender",type: "text",seen: "true"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver",type: "text",seen: "true"),
    ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender",type: "text",seen: "false"),
    ChatMessage(messageContent: "I am fine thanks.", messageType: "sender",type: "text",seen: "false"),
    ChatMessage(messageContent: "You look beautiful! :D", messageType: "sender",type: "text",seen: "false"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding:const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon:const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.redcolor,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    maxRadius: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.name,style: TextStyle( fontFamily: 'Poppins-Medium',fontSize: 13.sp),),
                        Text("active now",style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.sp),),
                        Text("00:15:31",style: TextStyle(fontFamily: 'Poppins-SemiBold', fontSize: 10.sp),),
                      ],
                    ),
                  ),
                  Image.asset(video,width: 30.w,height: 30.h,),
                  SizedBox(width: 10.w),
                  Icon(FontAwesomeIcons.ellipsisVertical,color: AppColors.black,size: 25.sp,),
                ],
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding:const EdgeInsets.only(left: 20,right: 20),
              height: 30.h,
              width: double.infinity,
              color: Colors.black.withOpacity(0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("This chat will self destruct soon.",style: TextStyle(color: AppColors.shadeLight,fontSize: 11.sp,fontFamily: 'Poppins-Regular'),),
                  Text("turn off chat timer",style: TextStyle(color: AppColors.shadeLight,fontSize: 11.sp,fontFamily: 'Poppins-Regular'))

                ],

              ),
            ),
          ),
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding:const EdgeInsets.only(top: 30,bottom: 50,),

            itemBuilder: (context, index){
              return
                messages[index].type=="text"?
                Container(
                padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Column(
                    crossAxisAlignment: messages[index].messageType == "receiver"?  CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:messages[index].messageType  == "receiver"? BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomRight: Radius.circular(15.r)):
                          BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomLeft: Radius.circular(15.r)),
                          color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:AppColors.chatColor),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15.sp,fontFamily: 'Poppins-Regular',color: AppColors.shadeText),),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment:  messages[index].messageType  == "receiver"?  MainAxisAlignment.start:
                        MainAxisAlignment.end,
                        children: [
                          Text("12:07 AM",style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                          SizedBox(width: 5.w),
                          Image.asset(tick,width: 15.w,height: 15.h,color:messages[index].seen=="true"?null:AppColors.lightGrey ,)
                        ],
                      )
                    ],
                  ),
                ),
              ):
                Container(
                  padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(messages[index].messageContent,width: 185.w,height: 126.h,)),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment:  messages[index].messageType  == "receiver"?  MainAxisAlignment.start:
                          MainAxisAlignment.end,
                          children: [
                            Text("12:07 AM",style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                            SizedBox(width: 5.w),
                            Image.asset(tick,width: 15.w,height: 15.h,color:messages[index].seen=="true"?null:AppColors.lightGrey ,)
                          ],
                        )
                      ],
                    ),
                    ),
                );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding:const EdgeInsets.only(left: 20,bottom: 10,top: 10,right: 20),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Image.asset(camera,width: 26.w,height: 26.h,),
                  ),
                  const SizedBox(width: 15,),
                   Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.redcolor,width: 1.w)
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(mic),
                          ),
                          contentPadding: const EdgeInsets.only(left: 10,bottom: 10),
                            hintText: "Message...",
                            hintStyle: TextStyle(color:const Color(0xFF636363),fontFamily: 'Poppins-Regular',fontSize: 16.sp),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ),

                ],

              ),
            ),
          ),

        ],
      ),
    );
  }
}