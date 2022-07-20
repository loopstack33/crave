// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/chat_room_model.dart';
import '../../../../model/chat_users.dart';
import '../../../../model/userModel.dart';
import '../../../../services/fcm_services.dart';
import '../../../../utils/color_constant.dart';
import '../../../../widgets/conversationList.dart';
import '../../../../widgets/custom_toast.dart';
import 'chat_helper.dart';
import 'chat_room.dart';
import 'favoriteChat.dart';


class UserChatList extends StatefulWidget {
  UserChatList({Key? key}) : super(key: key);

  @override
  State<UserChatList> createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> with WidgetsBindingObserver {
  TextEditingController searchController = TextEditingController();
  
  // List<MyUserModel> supportManList = [
  //   MyUserModel(
  //       uid: "",
  //       username: "Select Counselor",
  //       phone: "",
  //       status: 'online',
  //       bio: '',
  //       facebook: '',
  //       linkedIn: '',
  //       dribble: '',
  //       twitter: '',
  //       deviceToken: ''),
  // ];
  
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
   // getPref();
    getData();
    super.initState();
  }

  String number = '';
  String userName = '';
  String uid = '';
  
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      number = preferences.getString('number').toString();
      userName = preferences.getString('username').toString();
      uid = preferences.getString('uid').toString();
      log('getPref uid: ${uid}');
    });
    getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool loading = true;
  bool dialogOpen = false;
  var currentUser, currentUsername;
  FirebaseAuth auth = FirebaseAuth.instance;

  getData() async {
    //log("Getting Data________________");
    currentUser = await FirebaseHelper.getUserModelById(auth.currentUser!.uid);
 //   log('currentUser: $currentUser');

    FirebaseHelper.updateUserStatus(auth.currentUser!.uid, 'online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      log('isBackground____________________________________________________: $isBackground');
      FirebaseHelper.updateUserStatus(uid, 'offline');
    } else {
      FirebaseHelper.updateUserStatus(uid, 'online');
    }
  }

  late UsersModel dropdownUser;
  var selectedUser;
  String selectedChatRoomId = '';

  static ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> assignCounselor(BuildContext context, targetID, userID) async {
    log('userID: $userID');
    log('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
      "participants.${userID}",
      isEqualTo: "user",
    )
        .where(
      "participants.${targetID}",
      isEqualTo: "admin",
    )
        .get();

    if (snapshot.docs.length > 0) {
      log("ChatRoom Available");

      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatRoom =
      ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      log("Exiting chat Room : ${existingChatRoom.chatroomid}");
      log("Exiting chat participants : ${existingChatRoom.participants}");
      chatRoom = existingChatRoom;

      ToastUtils.showCustomToast(
          context, "Counsoler Already Assign ", Colors.red);
    } else {
      log("ChatRoom Not Available");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: const Uuid().v1(),
        lastMessage: "",
        participants: {
          targetID.toString(): "admin",
          userID.toString(): "user",
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;

      FCMServices.sendFCM("crave", targetID.toString(), "New Refer", "You add a new chat as a Counselor kindly proceed");
      ToastUtils.showCustomToast(context, "Counselor Assign Success", Colors.green);
    }
    setState(() {
      dialogOpen = false;
    });

    return chatRoom;
  }

  List participantKeys = [];
  var pUserId;

  @override
  Widget build(BuildContext context) {
    log(uid.toString());

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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                     .where("participants.${auth.currentUser!.uid}", isEqualTo: auth.currentUser!.uid)
                      .snapshots(),
                  builder:(context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);
                            Map<dynamic, dynamic> participants =
                            chatRoomModel.participants!;
                            List<dynamic> participantKeys = participants.keys.toList();

                            participantKeys.remove(auth.currentUser!.uid);
                            DateTime date =  DateTime.fromMillisecondsSinceEpoch(int.parse(chatRoomModel.timeStamp!));
                            var format = DateFormat.jm();
                            var dateString = format.format(date);
                            log(dateString.toString());

                            return FutureBuilder(
                              future: FirebaseHelper.getFromAllDatabase(participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    var targetUser = userData.data as Map;

                                    return Container(
                                      padding:const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              children: <Widget>[
                                                Badge(
                                                  shape: BadgeShape.circle,
                                                  badgeColor:
                                                  targetUser['status'].toString() == "online"
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                  position: BadgePosition.bottomEnd(
                                                    bottom: 0,
                                                    end: 0,
                                                  ),
                                                  padding: const EdgeInsets.all(2),
                                                  badgeContent: Container(
                                                      width: 10.w,
                                                      height: 10.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: targetUser['status']
                                                            .toString() ==
                                                            "online"
                                                            ? Colors.green
                                                            : Colors.grey,
                                                      )),
                                                  child:  SizedBox(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        targetUser['imageUrl'][0].toString(),
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
                                                ),
                                                SizedBox(width: 16.w),
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(targetUser['name'].toString(), style: TextStyle(fontSize: 18.sp,fontFamily: 'Poppins-Medium',color: AppColors.black),),
                                                        (chatRoomModel.lastMessage.toString() != "") ? chatRoomModel.lastMessage.toString() == "Image File"
                                                        ? Row(
                                                          children: [
                                                            Icon(FontAwesomeIcons.image,
                                                                size: 15.sp),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                             Text("Photo",style: TextStyle(fontSize: 14.sp,color: AppColors.fontColor, fontFamily: 'Poppins-Regular'),)
                                                          ],
                                                        )
                                                            : chatRoomModel.lastMessage
                                                            .toString() ==
                                                            "audioFile"
                                                            ? Row(
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons.microphone,
                                                              size: 15.sp,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                             Text("Audio message",style: TextStyle(fontSize: 14.sp,color: AppColors.fontColor, fontFamily: 'Poppins-Regular'),)
                                                          ],
                                                        )
                                                            : Text(chatRoomModel
                                                            .lastMessage
                                                            .toString(),style: TextStyle(fontSize: 14.sp,color: AppColors.fontColor, fontFamily: 'Poppins-Regular'),):
                                                            const Text("H")
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(dateString.toString(),style: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins-Medium',color: chatRoomModel.read==true?AppColors.darkGrey:AppColors.lightGrey)),
                                              chatRoomModel.idFrom != uid ? chatRoomModel.read == false && chatRoomModel.count.toString() != "0" ?
                                              Container(
                                                decoration:const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.redcolor
                                                ),
                                                padding:const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                                margin:const EdgeInsets.all(2),
                                                child: Text( chatRoomModel.count.toString(),style: TextStyle(fontSize: 7.5.sp,fontFamily: 'Poppins-Medium',color: AppColors.white),),
                                              ):const SizedBox():const SizedBox()
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  /*  return ListTile(
                                      onTap: () {
                                        if (chatRoomModel.toString() != "null") {
                                          AppRoutes.push(context, PageTransitionType.leftToRight, ChatRoom(
                                            status: targetUser['status']
                                                .toString(),
                                            targetUser: UsersModel(
                                              userId: targetUser['uid'].toString(),
                                              userName: targetUser['name'].toString(),
                                              phoneNumber: targetUser['phone'].toString(),
                                              status: targetUser['status'],
                                              bio: targetUser['bio'],
                                              userToken: targetUser['deviceToken'],
                                              imgUrl: [],
                                              craves: [],
                                              package: targetUser['package'],
                                              genes: targetUser['genes'],
                                              birthday:targetUser['birthday'],
                                              gender: targetUser['gender'],
                                            ),
                                            userModel: UsersModel(
                                              userId: currentUser['uid'].toString(),
                                              userName: currentUser['name'].toString(),
                                              phoneNumber: currentUser['phone'].toString(),
                                              status: currentUser['status'],
                                              bio: currentUser['bio'],
                                              userToken: currentUser['deviceToken'],
                                              imgUrl: [],
                                              craves: [],
                                              package: currentUser['package'],
                                              genes: currentUser['genes'],
                                              birthday:currentUser['birthday'],
                                              gender: currentUser['gender'],
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                        }
                                      },
                                      leading: Badge(
                                        shape: BadgeShape.circle,
                                        badgeColor:
                                        targetUser['status'].toString() == "online"
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        position: BadgePosition.bottomEnd(
                                          bottom: 0,
                                          end: 0,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        badgeContent: Container(
                                            width: 10.w,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: targetUser['status']
                                                  .toString() ==
                                                  "online"
                                                  ? Colors.green
                                                  : Colors.grey,
                                            )),
                                        child:  SizedBox(
                                          width: 50.w,
                                          height: 50.h,
                                          child: ClipOval(
                                            child: Image.network(
                                              targetUser['imageUrl'][0].toString(),
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
                                      ),
                                      title: Text(
                                          targetUser['name'].toString()),
                                      trailing: chatRoomModel.idFrom != uid
                                          ? chatRoomModel.read == false &&
                                          chatRoomModel.count
                                              .toString() !=
                                              "0"
                                          ? Container(
                                        width: 30.w,
                                        height: 20.h,
                                        decoration:const BoxDecoration(
                                            color: AppColors
                                                .redcolor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Text(
                                              chatRoomModel.count
                                                  .toString(),
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 8.sp),
                                            )),
                                      )
                                          : const SizedBox()
                                          : const SizedBox(),
                                      subtitle: (chatRoomModel.lastMessage
                                          .toString() !=
                                          "")
                                          ? chatRoomModel.lastMessage
                                          .toString() ==
                                          "Image File"
                                          ? Row(
                                        children: [
                                          Icon(FontAwesomeIcons.image,
                                              size: 15.sp),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Text("Photo")
                                        ],
                                      )
                                          : chatRoomModel.lastMessage
                                          .toString() ==
                                          "audioFile"
                                          ? Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.microphone,
                                            size: 15.sp,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Text("Audio message")
                                        ],
                                      )
                                          : Text(chatRoomModel
                                          .lastMessage
                                          .toString())
                                          : const Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color:
                                          AppColors.redcolor,
                                        ),
                                      ),
                                    );*/
                                  } else {
                                    return const Center(
                                      child: Text(""),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: Text(""),
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return const Center(
                          child: Text("No Chats"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              /*  ListView.builder(
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
                ),*/
              ],
            ),
          ),
        ),
      ),
     /* body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                     // .where("participants.${uid}", isEqualTo: 'user')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;

                        log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${chatRoomSnapshot.docs.length}");
                        return ListView.builder(
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            log('index: $index');
                            ChatRoomModel chatRoomModel =
                            ChatRoomModel.fromMap(
                                chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                            log(chatRoomModel.chatroomid.toString());

                           return Text("HELLO");

       return FutureBuilder(
                              future: FirebaseHelper.getFromAllDatabase(participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    var targetUser = userData.data as Map;

                                    return ListTile(
                                      onTap: () {
                                        if (chatRoomModel.toString() != "null") {
                                          AppRoutes.push(context, PageTransitionType.leftToRight, ChatRoom(
                                            status: targetUser['status']
                                                .toString(),
                                            targetUser: UsersModel(
                                              userId: targetUser['uid'].toString(),
                                              userName: targetUser['name'].toString(),
                                              phoneNumber: targetUser['phone'].toString(),
                                              status: targetUser['status'],
                                              bio: targetUser['bio'],
                                              userToken: targetUser['deviceToken'],
                                              imgUrl: [],
                                              craves: [],
                                              package: targetUser['package'],
                                              genes: targetUser['genes'],
                                              birthday:targetUser['birthday'],
                                              gender: targetUser['gender'],
                                            ),
                                            userModel: UsersModel(
                                              userId: currentUser['uid'].toString(),
                                              userName: currentUser['name'].toString(),
                                              phoneNumber: currentUser['phone'].toString(),
                                              status: currentUser['status'],
                                              bio: currentUser['bio'],
                                              userToken: currentUser['deviceToken'],
                                              imgUrl: [],
                                              craves: [],
                                              package: currentUser['package'],
                                              genes: currentUser['genes'],
                                              birthday:currentUser['birthday'],
                                              gender: currentUser['gender'],
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                        }
                                      },
                                      leading: Badge(
                                        shape: BadgeShape.circle,
                                        badgeColor:
                                        targetUser['status'].toString() == "online"
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        position: BadgePosition.bottomEnd(
                                          bottom: 0,
                                          end: 0,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        badgeContent: Container(
                                            width: 10.w,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: targetUser['status']
                                                  .toString() ==
                                                  "online"
                                                  ? Colors.green
                                                  : Colors.grey,
                                            )),
                                        child:  SizedBox(
                                          width: 50.w,
                                          height: 50.h,
                                          child: ClipOval(
                                            child: Image.network(
                                              targetUser['imageUrl'][0].toString(),
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
                                      ),
                                      title: Text(
                                          targetUser['name'].toString()),
                                      trailing: chatRoomModel.idFrom != uid
                                          ? chatRoomModel.read == false &&
                                          chatRoomModel.count
                                              .toString() !=
                                              "0"
                                          ? Container(
                                        width: 30.w,
                                        height: 20.h,
                                        decoration:const BoxDecoration(
                                            color: AppColors
                                                .redcolor,
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Text(
                                              chatRoomModel.count
                                                  .toString(),
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 8.sp),
                                            )),
                                      )
                                          : const SizedBox()
                                          : const SizedBox(),
                                      subtitle: (chatRoomModel.lastMessage
                                          .toString() !=
                                          "")
                                          ? chatRoomModel.lastMessage
                                          .toString() ==
                                          "Image File"
                                          ? Row(
                                        children: [
                                          Icon(FontAwesomeIcons.image,
                                              size: 15.sp),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Text("Photo")
                                        ],
                                      )
                                          : chatRoomModel.lastMessage
                                          .toString() ==
                                          "audioFile"
                                          ? Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.microphone,
                                            size: 15.sp,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          const Text("Audio message")
                                        ],
                                      )
                                          : Text(chatRoomModel
                                          .lastMessage
                                          .toString())
                                          : const Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color:
                                          AppColors.redcolor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(""),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: Text(""),
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return const Center(
                          child: Text("No Chats"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),


          ],
        ),
      ),*/
    );
  }
}

