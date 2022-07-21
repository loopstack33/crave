// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api
import 'package:crave/Screens/home/screens/chat/messagesWidgets/videoWidget.dart';
import 'package:crave/Screens/home/screens/chat/widgets/bottom_field_widget.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../model/chat_room_model.dart';
import '../../../../model/userModel.dart';
import '../../../../utils/color_constant.dart';
import '../../../../utils/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../model/message_model.dart';
import 'call/call_page.dart';
import 'messagesWidgets/display_text_gif.dart';

class ChatDetailPage extends StatefulWidget{
  final UsersModel targetUser;
  final ChatRoomModel chatRoom;
  final UsersModel userModel;
  final status;
  const ChatDetailPage({Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.status,}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>  with WidgetsBindingObserver{
  final ScrollController controller = ScrollController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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
                  SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: ClipOval(
                      child: Image.network(
                        widget.targetUser.imgUrl[0].toString(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
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
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.targetUser.userName,style: TextStyle( fontFamily: 'Poppins-Medium',fontSize: 13.sp),),
                        Row(children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.status.toString() == "online"
                                    ? Colors.lightGreenAccent
                                    : Colors.grey),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            widget.status.toString() == "online"
                                ? "Active Now"
                                : "Offline",style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.sp)

                          ),
                        ]),
                       // Text("active now",style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.sp),),
                        Text("00:15:31",style: TextStyle(fontFamily: 'Poppins-SemiBold', fontSize: 10.sp),),
                      ],
                    ),
                  ),
                  //Image.asset(video,width: 30.w,height: 30.h,),
                  GestureDetector(
                      onTap: (){
                        AppRoutes.push(context, PageTransitionType.fade,const CallPage());
                      },
                      child: Icon(FontAwesomeIcons.phone,color: AppColors.redcolor,size: 25.sp,)),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 55.0,top: 30.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(widget.chatRoom.chatroomid)
                  .collection("messages")
                  .orderBy("createdon", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot =
                    snapshot.data as QuerySnapshot;

                    // SchedulerBinding.instance.addPostFrameCallback((_) {
                    //   controller.jumpTo(controller.position.);
                    // });

                    return ListView.builder(
                      controller: controller,
                      reverse: true,
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                        // Text
                        return  currentMessage.type == "text" ?
                        Container(
                          padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                          child: Align(
                            alignment: ( (currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft),
                            child: Column(
                              crossAxisAlignment:  (currentMessage.sender == widget.userModel.userId)? CrossAxisAlignment.end: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: (currentMessage.sender == widget.userModel.userId)?
                                    BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomLeft: Radius.circular(15.r)):BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomRight: Radius.circular(15.r)),
                                    color: ( (currentMessage.sender == widget.userModel.userId)?AppColors.chatColor:Colors.grey.shade200),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text(currentMessage.text!, style: TextStyle(fontSize: 15.sp,fontFamily: 'Poppins-Regular',color: AppColors.shadeText),),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:  (currentMessage.sender == widget.userModel.userId)?  MainAxisAlignment.end:MainAxisAlignment.start,
                                  children: [
                                    Text(DateFormat.jm().format(currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                                    SizedBox(width: 5.w),
                                    Image.asset(tick,width: 15.w,height: 15.h,color:currentMessage.seen.toString() =="true"?null:AppColors.lightGrey ,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ):
                        // Image
                        currentMessage.type == "image" ?
                        Container(
                          padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                          child: Align(
                            alignment: (currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment:  (currentMessage.sender == widget.userModel.userId)? CrossAxisAlignment.end: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child:/* currentMessage
                                        .text !=
                                        ""
                                        ? */
                                        Image.network(
                                      currentMessage
                                          .text!,
                                      loadingBuilder: (BuildContext
                                      context,
                                          Widget
                                          child,
                                          ImageChunkEvent?
                                          loadingProgress) {
                                        if (loadingProgress ==
                                            null) {
                                          return child;
                                        }
                                        return Container(
                                          decoration:
                                          BoxDecoration(
                                            color:
                                            AppColors.white,
                                            borderRadius:
                                            BorderRadius.all(
                                              Radius.circular(8.r),
                                            ),
                                          ),
                                          width:
                                          200.w,
                                          height:
                                          200.h,
                                          child:
                                          Center(
                                            child:
                                            CircularProgressIndicator(
                                              color:
                                              AppColors.redcolor,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context,
                                          object,
                                          stackTrace) {
                                        return Material(
                                          borderRadius:
                                          BorderRadius.all(
                                            Radius.circular(
                                                8.r),
                                          ),
                                          clipBehavior:
                                          Clip.hardEdge,
                                          child: Image
                                              .asset(
                                            'assets/images/icon.png',
                                            width:
                                            200.w,
                                            height:
                                            200.h,
                                            fit: BoxFit
                                                .cover,
                                          ),
                                        );
                                      },
                                      width:
                                      200.w,
                                      height:
                                      200.h,
                                      fit: BoxFit
                                          .cover,
                                    )
                                        /*: Center(
                                      child: StreamBuilder<
                                          TaskSnapshot>(
                                          stream: uploadTask
                                              ?.snapshotEvents,
                                          builder:
                                              (context,
                                              snapshot) {
                                            if (snapshot
                                                .hasData) {
                                              final data =
                                                  snapshot.data;
                                              double
                                              progress =
                                              (data!.bytesTransferred / data.totalBytes);
                                              return SizedBox(
                                                width: 200.w,
                                                height: 200.h,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    SizedBox(
                                                      width: 60.w,
                                                      height: 60.h,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(70.0),
                                                        child: CircularProgressIndicator(value: progress, color: AppColors.redcolor, backgroundColor: Colors.grey),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        '${(100 * progress).roundToDouble()} %',
                                                        style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold, fontSize: 15.sp),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
                                    ),*/

                                  ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:  (currentMessage.sender == widget.userModel.userId)?
                                  MainAxisAlignment.end:  MainAxisAlignment.start,
                                  children: [
                                    Text(DateFormat.jm().format(currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                                    SizedBox(width: 5.w),
                                    Image.asset(tick,width: 15.w,height: 15.h,color:currentMessage.seen.toString()=="true"?null:AppColors.lightGrey ,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ):
                       // Audio
                        currentMessage.type == "Audio" ?
                        DisplayTextImageGIF(
                            message: currentMessage.text!,
                            type: "Audio",
                            currentMessage:currentMessage,userModel:widget.userModel
                        ):
                        // Video
                        currentMessage.type == "video" ?
                        VideoWidget(videoUrl: currentMessage.text!.toString(),currentMessage:currentMessage,userModel:widget.userModel)
                        : const SizedBox.shrink();


                      },
                    );


                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          "An error occurred! Please check your internet connection."),
                    );
                  } else {
                    return const Center(
                        child: Text(
                          "Say hi to your new friend",
                        )
                    );
                  }
                } else {
                  return const Center();
                }
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: BottomField(usersModel: widget.userModel,chatRoom: widget.chatRoom,targetUser: widget.targetUser),
          ),

        ],
      ),
    );
  }
}