// ignore_for_file: must_be_immutable, file_names

import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Screens/home/screens/chat/chatDetail.dart';

class ConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  String count;
  bool isMessageRead;
  ConversationList({Key? key, required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead,required this.count}) : super(key: key);
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage(
            name: widget.name,
            image: widget.imageUrl,
          );
        }));
      },
      child: Container(
        padding:const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30.r,
                    backgroundColor: AppColors.white,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 18.sp,fontFamily: 'Poppins-Medium',color: AppColors.black),),
                          Text(widget.messageText,style: TextStyle(fontSize: 14.sp,color: AppColors.fontColor, fontFamily: 'Poppins-Regular'),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
            Text(widget.time,style: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins-Medium',color: widget.isMessageRead?AppColors.darkGrey:AppColors.lightGrey)),
              widget.count.toString()=="0"?const SizedBox() :Container(
                  decoration:const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.redcolor
                  ),
                  padding:const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                  margin:const EdgeInsets.all(2),
                  child: Text(widget.count,style: TextStyle(fontSize: 7.5.sp,fontFamily: 'Poppins-Medium',color: AppColors.white),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}