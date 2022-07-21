import 'package:audioplayers/audioplayers.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../model/message_model.dart';
import '../../../../../model/userModel.dart';
import '../../../../../utils/images.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final String message;
  final String type;
  final MessageModel currentMessage;
  final UsersModel userModel;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.currentMessage,required this.userModel,
    required this.type,
  }) : super(key: key);

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
 //   bool isPlaying = false;
  //  final AudioPlayer audioPlayer = AudioPlayer();



    return StatefulBuilder(builder: (context, setState) {
      //LISTEN
      audioPlayer.onPlayerStateChanged.listen((state) {
        if(mounted){
          setState((){
            isPlaying = state == PlayerState.playing;
          });
        }
      });

      //DURATION
      audioPlayer.onDurationChanged.listen((newDuration) {
        if(mounted){
          setState((){
            duration = newDuration;
          });
        }
      });
      //POSITION
      audioPlayer.onDurationChanged.listen((pos) {
        if(mounted){
          setState((){
            position = pos;
          });
        }
      });
      return Container(
        padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
        child: Align(
          alignment: (widget.currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft,
          child: Column(
            crossAxisAlignment:  (widget.currentMessage.sender == widget.userModel.userId)? CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*0.5,
                decoration: BoxDecoration(
                  borderRadius: (widget.currentMessage.sender == widget.userModel.userId)?
                  BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomLeft: Radius.circular(15.r)):BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomRight: Radius.circular(15.r)),
                  color: ( (widget.currentMessage.sender == widget.userModel.userId)?AppColors.chatColor:const Color(0xFFF5F5F5)),
                ),
                child: Column(
                  children: [
                   Row(
                     children: [
                       IconButton(
                         onPressed: () async {
                           if (isPlaying) {
                             await audioPlayer.pause();
                             setState(() {
                               isPlaying = false;
                             });
                           } else {
                             await audioPlayer.play(UrlSource(widget.message));
                             setState(() {
                               isPlaying = true;
                             });
                           }
                         },
                         icon: Icon(
                           isPlaying ? Icons.pause_circle : Icons.play_circle,
                           color: AppColors.redcolor,
                         ),
                       ),
                       SizedBox(
                         width: 120.w,
                         child: Slider(
                           min: 0,
                           max: duration.inSeconds.toDouble(),
                           value: position.inSeconds.toDouble(),
                           onChanged: (value) async{
                             final pos = Duration(seconds: value.toInt());
                             await audioPlayer.seek(pos);
                             await audioPlayer.resume();
                           },
                         ),
                       ),
                     ],
                   ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0,right: 8,left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(duration-position)),
                          Text(formatTime(duration)),
                        ],
                      ),
                    )
                  ],
                )
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment:  (widget.currentMessage.sender == widget.userModel.userId)?  MainAxisAlignment.end:MainAxisAlignment.start,
                children: [
                  Text(DateFormat.jm().format(widget.currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                  SizedBox(width: 5.w),
                  Image.asset(tick,width: 15.w,height: 15.h,color:widget.currentMessage.seen.toString() =="true"?null:AppColors.lightGrey ,)
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  String formatTime(Duration duration) {
   String twoDigits(int n)=> n.toString().padLeft(2,'0');
   final hours= twoDigits(duration.inHours);
   final minutes= twoDigits(duration.inMinutes.remainder(60));
   final secs= twoDigits(duration.inSeconds.remainder(60));

   return [if(duration.inHours >0) hours,minutes,secs].join(':');
  }
}