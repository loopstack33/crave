import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../model/chat_room_model.dart';
import '../../../../../model/userModel.dart';
import '../../../../../utils/app_routes.dart';
import '../../../../../utils/color_constant.dart';
import '../chatDetail.dart';
import '../chat_helper.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({Key? key}) : super(key: key);

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget>
    with WidgetsBindingObserver {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var currentUser;

  @override
  void initState() {
    super.initState();
    getData();
    getuser();
    WidgetsBinding.instance.addObserver(this);
  }

  getData() async {
    currentUser = await FirebaseHelper.getUserModelById(auth.currentUser!.uid);
    FirebaseHelper.updateUserStatus(auth.currentUser!.uid, 'online');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<dynamic> photoUrl = [];
  String name = 'Name';
  getuser() async {
    String uid = auth.currentUser!.uid;
    await firebaseFirestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        name = value.data()!["name"];
        photoUrl = value.data()!["imageUrl"];
      });
    });
  }

  blockuser(String idTarget) async {
    await firebaseFirestore
        .collection("users")
        .doc(idTarget)
        .collection("blocked_By")
        .doc(auth.currentUser!.uid.toString())
        .set({
      'name': name.toString(),
      'imageUrl': photoUrl[0].toString(),
      'blockedId': auth.currentUser!.uid.toString()
    }).then((text) {
      ToastUtils.showCustomToast(context, "User Blocked", Colors.green);
    }).catchError((e) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      FirebaseHelper.updateUserStatus(auth.currentUser!.uid, 'offline');
    } else {
      FirebaseHelper.updateUserStatus(auth.currentUser!.uid, 'online');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${auth.currentUser!.uid}",
              isEqualTo: auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

            return chatRoomSnapshot.docs.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<dynamic, dynamic> participants =
                          chatRoomModel.participants!;
                      List<dynamic> participantKeys =
                          participants.keys.toList();

                      participantKeys.remove(auth.currentUser!.uid);
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatRoomModel.timeStamp!));
                      var format = DateFormat.jm();
                      var dateString = format.format(date);

                      return FutureBuilder(
                        future: FirebaseHelper.getFromAllDatabase(
                            participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              var targetUser = userData.data as Map;

                              return Slidable(
                                key: const ValueKey(0),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        QuerySnapshot snapshot =
                                            await FirebaseFirestore.instance
                                                .collection("chatrooms")
                                                .where(
                                                  "chatroomid",
                                                  isEqualTo: chatRoomModel
                                                      .chatroomid
                                                      .toString(),
                                                )
                                                .get();
                                        if (snapshot.docs.isNotEmpty) {
                                          for (int i = 0;
                                              i < snapshot.docs.length;
                                              i++) {
                                            snapshot.docs[i].reference.delete();
                                          }
                                          log("deleted idfrom chat");
                                        }
                                      },
                                      backgroundColor: AppColors.redcolor,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        if (chatRoomModel.roomcreator ==
                                            auth.currentUser!.uid) {
                                          blockuser(chatRoomModel.targetId
                                              .toString());

                                          QuerySnapshot snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection("chatrooms")
                                                  .where(
                                                    "chatroomid",
                                                    isEqualTo: chatRoomModel
                                                        .chatroomid
                                                        .toString(),
                                                  )
                                                  .get();
                                          if (snapshot.docs.isNotEmpty) {
                                            for (int i = 0;
                                                i < snapshot.docs.length;
                                                i++) {
                                              snapshot.docs[i].reference
                                                  .delete();
                                            }
                                          }
                                          QuerySnapshot snapshot1 =
                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(auth.currentUser!.uid)
                                                  .collection("likes")
                                                  .where(
                                                    "likedId",
                                                    isEqualTo: chatRoomModel
                                                        .targetId
                                                        .toString(),
                                                  )
                                                  .get();
                                          if (snapshot1.docs.isNotEmpty) {
                                            for (int i = 0;
                                                i < snapshot1.docs.length;
                                                i++) {
                                              snapshot1.docs[i].reference
                                                  .delete();
                                            }
                                          }
                                        } else {
                                          blockuser(chatRoomModel.roomcreator
                                              .toString());
                                          QuerySnapshot snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection("chatrooms")
                                                  .where(
                                                    "chatroomid",
                                                    isEqualTo: chatRoomModel
                                                        .chatroomid
                                                        .toString(),
                                                  )
                                                  .get();
                                          if (snapshot.docs.isNotEmpty) {
                                            for (int i = 0;
                                                i < snapshot.docs.length;
                                                i++) {
                                              snapshot.docs[i].reference
                                                  .delete();
                                            }
                                          }
                                          QuerySnapshot snapshot1 =
                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(auth.currentUser!.uid)
                                                  .collection("likes")
                                                  .where(
                                                    "likedId",
                                                    isEqualTo: chatRoomModel
                                                        .roomcreator
                                                        .toString(),
                                                  )
                                                  .get();
                                          if (snapshot1.docs.isNotEmpty) {
                                            for (int i = 0;
                                                i < snapshot1.docs.length;
                                                i++) {
                                              snapshot1.docs[i].reference
                                                  .delete();
                                            }
                                          }
                                        }
                                      },
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      icon: Icons.block,
                                      label: 'Block',
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    log(chatRoomModel.chatroomid.toString());
                                    if (chatRoomModel.toString() != "null") {
                                      AppRoutes.push(
                                          context,
                                          PageTransitionType.rightToLeft,
                                          ChatDetailPage(
                                            status:
                                                targetUser['status'].toString(),
                                            targetUser: UsersModel(
                                                userId: targetUser['uid']
                                                    .toString(),
                                                userName: targetUser['name']
                                                    .toString(),
                                                phoneNumber: targetUser['phone']
                                                    .toString(),
                                                status: targetUser['status'],
                                                bio: targetUser['bio'],
                                                userToken:
                                                    targetUser['deviceToken'],
                                                imgUrl: targetUser['imageUrl'],
                                                craves: [],
                                                package: targetUser['package'],
                                                genes: targetUser['genes'],
                                                birthday:
                                                    targetUser['birthday'],
                                                gender: targetUser['gender'],
                                                showName:
                                                    targetUser['showName'],
                                                likedBy: targetUser['likedBy']),
                                            userModel: UsersModel(
                                              userId:
                                                  currentUser['uid'].toString(),
                                              userName: currentUser['name']
                                                  .toString(),
                                              phoneNumber: currentUser['phone']
                                                  .toString(),
                                              status: currentUser['status'],
                                              bio: currentUser['bio'],
                                              userToken:
                                                  currentUser['deviceToken'],
                                              imgUrl: currentUser['imageUrl'],
                                              craves: [],
                                              package: currentUser['package'],
                                              genes: currentUser['genes'],
                                              birthday: currentUser['birthday'],
                                              gender: currentUser['gender'],
                                              showName: currentUser['showName'],
                                              likedBy: currentUser['likedBy'],
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: targetUser[
                                                              "status"] ==
                                                          "online"
                                                      ? [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.green,
                                                              blurRadius: 15.r,
                                                              offset:
                                                                  const Offset(
                                                                      0, 1.5))
                                                        ]
                                                      : null,
                                                ),
                                                width: 50.w,
                                                height: 50.h,
                                                child: ClipOval(
                                                  child: Image.network(
                                                    targetUser['imageUrl'][0]
                                                        .toString(),
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            ctx,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
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
                                                        style: TextStyle(
                                                            fontSize: 16.sp),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16.w),
                                              Expanded(
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        targetUser['name']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            fontFamily:
                                                                'Poppins-Medium',
                                                            color: AppColors
                                                                .black),
                                                      ),
                                                      (chatRoomModel.lastMessage
                                                                  .toString() !=
                                                              "")
                                                          ? chatRoomModel
                                                                      .lastMessage
                                                                      .toString() ==
                                                                  "Image File"
                                                              ? Text(
                                                                  "📷 Photo",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: AppColors
                                                                          .fontColor,
                                                                      fontFamily:
                                                                          'Poppins-Regular'),
                                                                )
                                                              : chatRoomModel
                                                                          .lastMessage
                                                                          .toString() ==
                                                                      "Audio"
                                                                  ? Text(
                                                                      "🎵 Audio",
                                                                      style: TextStyle(
                                                                          fontSize: 14
                                                                              .sp,
                                                                          color: AppColors
                                                                              .fontColor,
                                                                          fontFamily:
                                                                              'Poppins-Regular'),
                                                                    )
                                                                  : chatRoomModel
                                                                              .lastMessage
                                                                              .toString() ==
                                                                          "Video"
                                                                      ? Text(
                                                                          "📸 Video",
                                                                          style: TextStyle(
                                                                              fontSize: 14.sp,
                                                                              color: AppColors.fontColor,
                                                                              fontFamily: 'Poppins-Regular'),
                                                                        )
                                                                      : Text(
                                                                          chatRoomModel
                                                                              .lastMessage
                                                                              .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 14.sp,
                                                                              color: AppColors.fontColor,
                                                                              fontFamily: 'Poppins-Regular'),
                                                                        )
                                                          : Text(
                                                              "Say hi✋ to your new friend",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: AppColors
                                                                      .fontColor,
                                                                  fontFamily:
                                                                      'Poppins-Regular'))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(dateString.toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        'Poppins-Medium',
                                                    color: chatRoomModel.read ==
                                                            true
                                                        ? AppColors.darkGrey
                                                        : AppColors.lightGrey)),
                                            chatRoomModel.idFrom !=
                                                    auth.currentUser!.uid
                                                ? chatRoomModel.read == false &&
                                                        chatRoomModel.count
                                                                .toString() !=
                                                            "0"
                                                    ? Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppColors
                                                                    .redcolor),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5,
                                                                right: 5,
                                                                top: 2,
                                                                bottom: 2),
                                                        margin: const EdgeInsets
                                                            .all(2),
                                                        child: Text(
                                                          chatRoomModel.count
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 7.5.sp,
                                                              fontFamily:
                                                                  'Poppins-Medium',
                                                              color: AppColors
                                                                  .white),
                                                        ),
                                                      )
                                                    : const SizedBox()
                                                : const SizedBox()
                                          ],
                                        ),
                                      ],
                                    ),
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
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Image.asset("assets/images/i3.png"),
                          Text(
                            "No Chats Found",
                            style: TextStyle(
                                fontSize: 20.sp, fontFamily: 'Poppins-Regular'),
                          )
                        ],
                      ),
                    ),
                  );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Image.asset("assets/images/i3.png"),
                    Text(
                      "No Chats Found",
                      style: TextStyle(
                          fontSize: 20.sp, fontFamily: 'Poppins-Regular'),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.redcolor,
            ),
          );
        }
      },
    );
  }
}
