// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/model/chat_room_model.dart';
import 'package:crave/services/fcm_services.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pay/pay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String name = 'Name';
  String id = '';
  String? currentGender;
  List<dynamic> photoUrl = [];
  @override
  void initState() {
    getLikes();
    super.initState();
    getData();
  }

  getData() async {
    String uid = _auth.currentUser!.uid;
    await firebaseFirestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        id = value.data()!["uid"];
        photoUrl = value.data()!["imageUrl"];
        name = value.data()!["name"];
        currentGender = value.data()!["gender"];
      });
    });
  }

  static ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> assignChatRoom(
      BuildContext context, userName, token, targetID, userID) async {
    log('userID: $userID');
    log('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where(
          "participants.$userID",
          isEqualTo: userID,
        )
        .where(
          "participants.$targetID",
          isEqualTo: targetID,
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
      Navigator.pop(context);
      ToastUtils.showCustomToast(
          context, "Chat room already assigned", Colors.red);
    } else {
      log("ChatRoom Not Available");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: const Uuid().v1(),
        lastMessage: "",
        read: false,
        idFrom: "",
        paid: false,
        idTo: "",
        count: 0,
        dateTime: DateTime.now().toString(),
        timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
        participants: {
          targetID.toString(): targetID.toString(),
          userID.toString(): userID.toString(),
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
      // AppRoutes.push(context, PageTransitionType.fade,  UserChatList(isDash: true,));
      Navigator.pop(context);
      FCMServices.sendFCM(token, targetID.toString(), name.toString(),
          "Want's to chat with you.");
      ToastUtils.showCustomToast(
          context, "ChatRoom Assigned Success", Colors.green);
    }

    return chatRoom;
  }

  getLikes() async {
    await firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("likes")
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          count = value.docs.length;
        });
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Text(
                'Likes You',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  color: AppColors.black,
                  fontSize: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.redcolor),
                padding:
                    const EdgeInsets.only(left: 3, right: 3, top: 2, bottom: 2),
                margin: const EdgeInsets.all(2),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Poppins-SemiBold',
                      color: AppColors.white),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 120.h,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(_auth.currentUser!.uid)
                .collection("likes")
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30.r,
                        child: ClipOval(child: Container()),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30.r,
                        child: ClipOval(child: Container()),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30.r,
                        child: ClipOval(child: Container()),
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30.r,
                        child: ClipOval(child: Container()),
                      ),
                    ],
                  ),
                );
              } else {
                final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    snapshot.data!.docs;

                return docs.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (currentGender == "Man") {
                          const paymentItems = [
                            PaymentItem(
                              label: 'Crave ChatPay',
                              amount: '1.99',
                              status: PaymentItemStatus.final_price,
                            )
                          ];
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: 515.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(14.r),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            width: 515.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.redcolor,
                                              borderRadius:
                                              BorderRadius.only(
                                                  topLeft: Radius
                                                      .circular(
                                                      14.r),
                                                  topRight: Radius
                                                      .circular(
                                                      14.r)),
                                            ),
                                            child: Align(
                                              alignment:
                                              Alignment.center,
                                              child: Text(
                                                "Action Required",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.white,
                                                    fontFamily:
                                                    'Poppins-Medium',
                                                    fontSize: 22.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration:
                                                  const BoxDecoration(
                                                    shape:
                                                    BoxShape.circle,
                                                    color: AppColors
                                                        .redcolor,
                                                  ),
                                                  child: Image.asset(
                                                      icon)),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black,
                                                    fontFamily:
                                                    'Poppins-Medium',
                                                    fontSize: 20.sp),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "For chatting without liking pay 1.99 \$.",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w300,
                                                color: Colors.black,
                                                fontFamily:
                                                'Poppins-Regular',
                                                fontSize: 18.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              ApplePayButton(
                                                width: 200,
                                                height: 50,
                                                paymentConfigurationAsset:
                                                'files/applepay.json',
                                                paymentItems:
                                                paymentItems,
                                                style:
                                                ApplePayButtonStyle
                                                    .black,
                                                type: ApplePayButtonType
                                                    .buy,
                                                margin: const EdgeInsets
                                                    .only(top: 15.0),
                                                onPaymentResult:
                                                    (data) {
                                                  print(data);
                                                  assignChatRoom(
                                                    context,
                                                    name,
                                                    docs[index]
                                                    ['deviceToken'],
                                                    docs[index]
                                                    ["likedId"],
                                                    id,
                                                  );
                                                },
                                                onError: (data) {
                                                  ToastUtils
                                                      .showCustomToast(
                                                      context,
                                                      "Payment Failed",
                                                      Colors.red);
                                                },
                                                loadingIndicator:
                                                const Center(
                                                  child:
                                                  CircularProgressIndicator(),
                                                ),
                                              ),
                                              GooglePayButton(
                                                width: 200,
                                                height: 50,
                                                paymentConfigurationAsset:
                                                'files/gpay.json',
                                                paymentItems:
                                                paymentItems,
                                                style:
                                                GooglePayButtonStyle
                                                    .black,
                                                type:
                                                GooglePayButtonType
                                                    .pay,
                                                margin: const EdgeInsets
                                                    .only(top: 15.0),
                                                onPaymentResult:
                                                    (data) {
                                                  print(data);
                                                  assignChatRoom(
                                                    context,
                                                    name,
                                                    docs[index]
                                                    ['deviceToken'],
                                                    docs[index]
                                                    ["likedId"],
                                                    id,
                                                  );
                                                },
                                                onError: (data) {
                                                  ToastUtils
                                                      .showCustomToast(
                                                      context,
                                                      "Payment Failed",
                                                      Colors.red);
                                                },
                                                loadingIndicator:
                                                const Center(
                                                  child:
                                                  CircularProgressIndicator(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          assignChatRoom(
                            context,
                            name,
                            docs[index]['deviceToken'],
                            docs[index]["likedId"],
                            id,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 30.r,
                              child: ClipOval(
                                child: Image.network(
                                  docs[index]["imageUrl"],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext ctx,
                                      Widget child,
                                      ImageChunkEvent?
                                      loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
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
                                      style: TextStyle(fontSize: 16.sp),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              docs[index]["name"],
                              style: TextStyle(
                                color: AppColors.black,
                                fontFamily: 'Poppins-Medium',
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey,
                        //enabled: _enabled,

                        child: Center(
                          child: Text("No Likes",
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: 18.sp,
                              )),
                        ),
                      );
              }
            },
          ),
        ),
      ],
    );
  }
}
