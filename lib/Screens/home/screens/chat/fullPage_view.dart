import 'dart:ui';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoPage extends StatefulWidget {
  final String url;
  final bool type;

  const FullPhotoPage({Key? key, required this.url,required this.type}) : super(key: key);

  @override
  State<FullPhotoPage> createState() => _FullPhotoPageState();
}

class _FullPhotoPageState extends State<FullPhotoPage> {
  late CachedVideoPlayerController videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.url)..initialize().then((value)  {
      videoPlayerController.setVolume(1);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }
  bool isPlay = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.redcolor,
        centerTitle: true,
        title: Text(widget.type==true?"Photo View":"Video View",style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 20.sp,color: AppColors.white),),
      ),
      body:widget.type==true? PhotoView(
        imageProvider: NetworkImage(widget.url),
      ):
      Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
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
    );
  }
}