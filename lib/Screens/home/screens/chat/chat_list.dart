// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/chat/widgets/chatListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import '../../../../model/chat_room_model.dart';
import '../../../../services/fcm_services.dart';
import '../../../../utils/color_constant.dart';
import '../../../../widgets/custom_toast.dart';
import 'favoriteChat.dart';


class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  State<UserChatList> createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {


  bool loading = true;
  bool dialogOpen = false;

  static ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> assignCounselor(BuildContext context, targetID, userID) async {
    log('userID: $userID');
    log('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
      "participants.$userID",
      isEqualTo: "user",
    )
        .where(
      "participants.$targetID",
      isEqualTo: "admin",
    )
        .get();

    if (snapshot.docs.isNotEmpty) {
      log("ChatRoom Available");

      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatRoom =
      ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      log("Exiting chat Room : ${existingChatRoom.chatroomid}");
      log("Exiting chat participants : ${existingChatRoom.participants}");
      chatRoom = existingChatRoom;

      ToastUtils.showCustomToast(
          context, "Counselor Already Assign ", Colors.red);
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

