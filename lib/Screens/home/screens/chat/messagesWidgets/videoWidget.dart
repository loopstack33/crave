
import 'dart:ui';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../model/message_model.dart';
import '../../../../../model/userModel.dart';
import '../../../../../utils/images.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final MessageModel currentMessage;
  final UsersModel userModel;
  const VideoWidget({Key? key, required this.videoUrl,required this.currentMessage,required this.userModel}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value)  {
      videoPlayerController.setVolume(1);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),

       child: Align(
         alignment: (widget.currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft,
         child: Column(
           crossAxisAlignment:  (widget.currentMessage.sender == widget.userModel.userId)? CrossAxisAlignment.end: CrossAxisAlignment.start,
           children: [
             SizedBox(
               width: 200.w,
               height: 200.h,
               child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CachedVideoPlayer(videoPlayerController)),
                  Align(
                      alignment:Alignment.center,
                  child: ClipOval(

                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10, sigmaY: 10),
                      child: IconButton(
                          onPressed: (){
                            if(isPlay){
                              videoPlayerController.pause();
                            }
                            else{
                              videoPlayerController.play();
                            }
                            if(mounted){
                              setState((){
                                isPlay =!isPlay;
                              });
                            }
                          },
                          icon: Icon(isPlay?FontAwesomeIcons.pause :FontAwesomeIcons.play,color: AppColors.white,)),
                    ),
                  ),)
                ],
             ),
             ),
             SizedBox(height: 5.h),
             Row(
               mainAxisAlignment:  (widget.currentMessage.sender == widget.userModel.userId)?
               MainAxisAlignment.end:  MainAxisAlignment.start,
               children: [
                 Text(DateFormat.jm().format(widget.currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                 SizedBox(width: 5.w),
                 Image.asset(tick,width: 15.w,height: 15.h,color:widget.currentMessage.seen.toString()=="true"?null:AppColors.lightGrey ,)
               ],
             )
           ],
         ),
       ),);
  }
}
