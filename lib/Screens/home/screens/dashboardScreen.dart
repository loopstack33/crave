// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:developer';
import 'dart:ui';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/settings.dart';
import 'package:crave/model/userModel.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pay/pay.dart';
import 'package:uuid/uuid.dart';
import '../../../model/chat_room_model.dart';
import '../../../services/fcm_services.dart';
import '../../../widgets/custom_toast.dart';
import 'chat/chat_list.dart';

// This is the type used by the popup menu below.
enum Menu { BlockForever, Report }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoad = true;
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int selectedIndex = 0;
  List<dynamic> cravesHalf = [];
  bool viewMore = true;
  String viewMoreButton = "View More";
  UsersModel? allUsers;
  List<UsersModel> allUserexceptblocked = [];

  @override
  void initState() {
    super.initState();
    getData();
    getDataalluserexcepcurrent();
  }

  String id = '';
  List<dynamic> photoUrl = [];
  String name = 'Name';

  getData() async {
    String uid = _auth.currentUser!.uid;
    await firebaseFirestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        id = value.data()!["uid"];
        photoUrl = value.data()!["imageUrl"];
        name = value.data()!["name"];
      });
    });
  }

  getDataalluserexcepcurrent() async {
    allUserexceptblocked.clear();
    await firebaseFirestore
        .collection('users')
        .where('uid', isNotEqualTo: _auth.currentUser!.uid)
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        bool checkblock = await testing(value.docs[i]["uid"]);
        if (checkblock == false) {
          allUsers = UsersModel.fromDocument(value.docs[i]);
          allUserexceptblocked.add(allUsers!);
        }
      }
    });
    if (mounted) {
      setState(() {
        isLoad = false;
      });
    }
    log(allUserexceptblocked.length.toString());
  }

  String _selectedMenu = '';
  TextEditingController reportController = TextEditingController();
  bool feedLoad = false;



  static ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> assignChatRoom(BuildContext context,userName ,targetID, userID) async {
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

      ToastUtils.showCustomToast(context, "Chat room already assigned", Colors.red);
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
      AppRoutes.push(context, PageTransitionType.fade, const UserChatList());
      FCMServices.sendFCM("crave", targetID.toString(), name.toString(), "Want's to chat with you.");
      ToastUtils.showCustomToast(context, "ChatRoom Assigned Success", Colors.green);
    }

    return chatRoom;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          elevation: 1,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                onTap: () {
                  AppRoutes.push(context, PageTransitionType.leftToRight,
                      const SettingsScreen());
                },
                child: Image.asset(menu)),
          ),
          title: Image.asset(
            hLogo,
            width: 105.w,
            height: 18.h,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                bell,
                width: 20.w,
                height: 20.h,
              ),
            ),
          ],
        ),
        body: ProgressHUD(
          inAsyncCall: isLoad,
          opacity: 0.1,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: allUserexceptblocked.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.amber))
                  : ListView.builder(
                      itemCount: allUserexceptblocked.length,
                      itemBuilder: (context, index) {
                        List<dynamic> craves =
                            List.from(allUserexceptblocked[index].craves);
                        cravesHalf.clear();
                        if (craves.length > 3) {
                          for (int i = 0; i < craves.length / 2; i++) {
                            String temp;
                            temp = craves[i].toString();
                            cravesHalf.add(temp);
                          }
                        } else {
                          cravesHalf.add(craves[0].toString());
                        }

                        List<dynamic> imgList =
                            List.from(allUserexceptblocked[index].imgUrl);

                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(16.r)),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  FlutterCarousel(
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      enlargeCenterPage: true,
                                    ),
                                    items: imgList
                                        .map((item) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.r)),
                                                child: Image.network(
                                                  item,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext ctx,
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
                                            ))
                                        .toList(),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: PopupMenuButton<Menu>(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.r),
                                                  ),
                                                ),
                                                child: Image.asset(
                                                  report,
                                                  width: 35.w,
                                                  height: 35.h,
                                                ),
                                                onSelected: (Menu item) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _selectedMenu = item.name;
                                                    });
                                                  }
                                                  if (_selectedMenu
                                                          .toString() ==
                                                      "BlockForever") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r)),
                                                            elevation: 10,
                                                            backgroundColor:
                                                                AppColors.white,
                                                            child:
                                                                SingleChildScrollView(
                                                              child:
                                                                  StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setter) {
                                                                  return Column(
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(20.r),
                                                                              topRight: Radius.circular(20.r)),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              AppColors.redcolor.withOpacity(0.35),
                                                                              AppColors.redcolor
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        padding:
                                                                            const EdgeInsets.all(8),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Block User",
                                                                              style: TextStyle(fontSize: 22.sp, color: AppColors.white, fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Are you sure you want to block this\nuser forever?",
                                                                              style: TextStyle(fontSize: 16.sp, color: AppColors.black, fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              blockUser(name.toString(), photoUrl[0].toString(), allUserexceptblocked[index].userId.toString());
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 150.w,
                                                                              height: 40.h,
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                  colors: [
                                                                                    AppColors.redcolor.withOpacity(0.35),
                                                                                    AppColors.redcolor
                                                                                  ],
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(5.r),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text("Yes", style: TextStyle(fontSize: 20.sp, color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 150.w,
                                                                              height: 40.h,
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                  colors: [
                                                                                    AppColors.redcolor.withOpacity(0.35),
                                                                                    AppColors.redcolor
                                                                                  ],
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(5.r),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text("No", style: TextStyle(fontSize: 20.sp, color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  } else if (_selectedMenu
                                                          .toString() ==
                                                      "Report") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.r)),
                                                            elevation: 10,
                                                            backgroundColor:
                                                                AppColors.white,
                                                            child:
                                                                SingleChildScrollView(
                                                              child:
                                                                  StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setter) {
                                                                  return Column(
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(20.r),
                                                                              topRight: Radius.circular(20.r)),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              AppColors.redcolor.withOpacity(0.35),
                                                                              AppColors.redcolor
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        padding:
                                                                            const EdgeInsets.all(8),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Report User",
                                                                              style: TextStyle(fontSize: 22.sp, color: AppColors.white, fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin:
                                                                            const EdgeInsets.all(10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                const Color(0xFFB7B7B7),
                                                                            width:
                                                                                1, //                   <--- border width here
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.0.r),
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              reportController,
                                                                          maxLength:
                                                                              400,
                                                                          maxLines:
                                                                              2,
                                                                          style: TextStyle(
                                                                              fontSize: 18.sp,
                                                                              color: const Color(0xFF676060),
                                                                              fontFamily: 'Poppins',
                                                                              fontWeight: FontWeight.w300),
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                "Write your report message here...",
                                                                            hintStyle: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                color: AppColors.textColor,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontFamily: 'Poppins'),
                                                                            fillColor:
                                                                                const Color(0xFFFFFFFF),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12.0.r),
                                                                              borderSide: const BorderSide(
                                                                                color: AppColors.white,
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12.0.r),
                                                                              borderSide: BorderSide(
                                                                                color: AppColors.white,
                                                                                width: 1.0.r,
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(12.0.r),
                                                                              borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 2.0.r,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10.h,
                                                                      ),
                                                                      feedLoad
                                                                          ? const Center(
                                                                              child: CircularProgressIndicator(
                                                                                color: AppColors.redcolor,
                                                                              ),
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                if (reportController.text.isEmpty) {
                                                                                  ToastUtils.showCustomToast(context, "Please provide some message", Colors.amber);
                                                                                } else {
                                                                                  if (mounted) {
                                                                                    setState(() {
                                                                                      feedLoad = true;
                                                                                    });
                                                                                  }
                                                                                  isReport(allUserexceptblocked[index].userId.toString(), allUserexceptblocked[index].userName, allUserexceptblocked[index].imgUrl[0].toString());
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                width: 200.w,
                                                                                height: 40.h,
                                                                                decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(
                                                                                    begin: Alignment.topCenter,
                                                                                    end: Alignment.bottomCenter,
                                                                                    colors: [
                                                                                      AppColors.redcolor.withOpacity(0.35),
                                                                                      AppColors.redcolor
                                                                                    ],
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(5.r),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      FontAwesomeIcons.checkCircle,
                                                                                      color: AppColors.white,
                                                                                      size: 25.sp,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 10.w,
                                                                                    ),
                                                                                    Text("Submit", style: TextStyle(fontSize: 20.sp, color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<Menu>>[
                                                      PopupMenuItem<Menu>(
                                                        value:
                                                            Menu.BlockForever,
                                                        child: Text(
                                                          'Block Forever',
                                                          style: TextStyle(
                                                              color: const Color(
                                                                  0xFF2F2F48),
                                                              fontFamily:
                                                                  'Poppins-Regular',
                                                              fontSize: 14.sp),
                                                        ),
                                                      ),
                                                      PopupMenuItem<Menu>(
                                                        value: Menu.Report,
                                                        child: Text('Report',
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xFF2F2F48),
                                                                fontFamily:
                                                                    'Poppins-Regular',
                                                                fontSize:
                                                                    14.sp)),
                                                      ),
                                                    ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              text(
                                                  context,
                                                  allUserexceptblocked[index]
                                                      .userName,
                                                  22.sp,
                                                  color: AppColors.white,
                                                  fontFamily: 'Poppins-Medium'),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 10, sigmaY: 10),
                                                  child: Container(
                                                      color: AppColors
                                                          .containerborder
                                                          .withOpacity(0.6),
                                                      child: InkWell(
                                                        onTap: () {
                                                          const paymentItems = [
                                                            PaymentItem(
                                                              label: 'Crave ChatPay',
                                                              amount: '1.99',
                                                              status: PaymentItemStatus.final_price,
                                                            )
                                                          ];
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  elevation: 0.0,
                                                                  backgroundColor: Colors.transparent,
                                                                  child: Container(
                                                                    width: 515.w,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(14.r),
                                                                    ),
                                                                    child: SingleChildScrollView(
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                                                                            width: 515.w,
                                                                            decoration: BoxDecoration(
                                                                              color: AppColors.redcolor,
                                                                              borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(14.r),
                                                                                  topRight: Radius.circular(14.r)),
                                                                            ),
                                                                            child: Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                "Action Required",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'Poppins-Medium',
                                                                                    fontSize: 22.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 10.h),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                  width: 50.w,
                                                                                  height: 50.h,
                                                                                  decoration: const BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: AppColors.redcolor,
                                                                                  ),
                                                                                  child: Image.asset(icon)),
                                                                              SizedBox(
                                                                                width: 20.w,
                                                                              ),
                                                                              Text(
                                                                                "Confirm",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontFamily: 'Poppins-Medium',
                                                                                    fontSize: 20.sp),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: 10.h),
                                                                          Text(
                                                                            "For chatting without liking pay 1.99 \$.",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.black,
                                                                                fontFamily: 'Poppins-Regular',
                                                                                fontSize: 18.sp),
                                                                            textAlign: TextAlign.center,
                                                                          ),
                                                                          SizedBox(
                                                                            height: 10.h,
                                                                          ),
                                                                          ElevatedButton(onPressed: (){
                                                                            assignChatRoom(
                                                                              context,
                                                                              allUserexceptblocked[index].userName,
                                                                              allUserexceptblocked[index].userId,
                                                                              _auth.currentUser!.uid,
                                                                            );

                                                                          }, child: const Text("CHAT")),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              ApplePayButton(
                                                                                width: 200,
                                                                                height: 50,
                                                                                paymentConfigurationAsset: 'files/applepay.json',
                                                                                paymentItems: paymentItems,
                                                                                style: ApplePayButtonStyle.black,
                                                                                type: ApplePayButtonType.buy,
                                                                                margin: const EdgeInsets.only(top: 15.0),
                                                                                onPaymentResult: (data){
                                                                                  print(data);
                                                                                },
                                                                                loadingIndicator: const Center(
                                                                                  child: CircularProgressIndicator(),
                                                                                ),
                                                                              ),
                                                                              GooglePayButton(
                                                                                width: 200,
                                                                                height: 50,
                                                                                paymentConfigurationAsset: 'files/gpay.json',
                                                                                paymentItems: paymentItems,
                                                                                style: GooglePayButtonStyle.black,
                                                                                type: GooglePayButtonType.pay,
                                                                                margin: const EdgeInsets.only(top: 15.0),
                                                                                onPaymentResult:  (data){
                                                                                  print(data);
                                                                                },
                                                                                loadingIndicator: const Center(
                                                                                  child: CircularProgressIndicator(),
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
                                                        },
                                                        child: Image.asset(
                                                          lockedchat,
                                                          width: 48,
                                                          height: 48,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.r),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 10, sigmaY: 10),
                                                  child: Container(
                                                      color: AppColors
                                                          .containerborder
                                                          .withOpacity(0.6),
                                                      child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () async {
                                                            bool exits = await isItems(
                                                                allUserexceptblocked[
                                                                        index]
                                                                    .userId
                                                                    .toString());

                                                            if (exits) {
                                                              getlikedIds(
                                                                  allUserexceptblocked[
                                                                          index]
                                                                      .userId
                                                                      .toString());
                                                            } else {
                                                              likeUser(
                                                                  name
                                                                      .toString(),
                                                                  photoUrl[0]
                                                                      .toString(),
                                                                  allUserexceptblocked[
                                                                          index]
                                                                      .userId
                                                                      .toString());
                                                            }
                                                          },
                                                          icon: selectedIndex ==
                                                                  index
                                                              ? loading
                                                                  ? SizedBox(
                                                                      width:
                                                                          25.w,
                                                                      height:
                                                                          25.h,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: AppColors
                                                                            .redcolor,
                                                                        strokeWidth:
                                                                            2.0.w,
                                                                      ))
                                                                  : Icon(
                                                                      FontAwesomeIcons
                                                                          .solidHeart,
                                                                      size:
                                                                          28.sp,
                                                                      color: AppColors
                                                                          .white,
                                                                    )
                                                              : Icon(
                                                                  FontAwesomeIcons
                                                                      .solidHeart,
                                                                  size: 28.sp,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                ))),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Image.asset(
                                    allUserexceptblocked[index].gender == "Man"
                                        ? male
                                        : allUserexceptblocked[index].gender ==
                                                "Woman"
                                            ? female
                                            : other,
                                    color: Colors.white,
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 5.w),
                                  Image.asset(
                                    allUserexceptblocked[index].genes ==
                                            "Hetero"
                                        ? hetero
                                        : allUserexceptblocked[index].genes ==
                                                "Lesbian"
                                            ? lesbian
                                            : allUserexceptblocked[index]
                                                        .genes ==
                                                    "Gay"
                                                ? gay
                                                : bisexual,
                                    color: Colors.white,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              text(context, allUserexceptblocked[index].bio,
                                  12.sp,
                                  color: AppColors.white,
                                  fontFamily: 'Poppins-Regular'),
                              SizedBox(height: 10.h),
                              SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                    spacing: 8.0, // gap between adjacent chips
                                    runSpacing: 4.0, // gap between lines
                                    children: selectedIndex == index &&
                                            viewMore == true
                                        ? cravesHalf
                                            .map((e) => Chip(
                                                  labelPadding:
                                                      const EdgeInsets.all(2.0),
                                                  avatar: CircleAvatar(
                                                    backgroundColor:
                                                        AppColors.chipColor,
                                                    child: Image.asset(
                                                        e == "Casual Dating"
                                                            ? casualdating
                                                            : e == "No String Attached"
                                                                ? nostring1
                                                                : e == "In Person"
                                                                    ? inperson
                                                                    : e == "Sexting"
                                                                        ? sexting2
                                                                        : e == "Kinky"
                                                                            ? kinky
                                                                            : e == "Vanilla"
                                                                                ? vanilla
                                                                                : e == "Submissive"
                                                                                    ? submissive
                                                                                    : e == "Dominance"
                                                                                        ? dominance
                                                                                        : e == "Dress Up"
                                                                                            ? dressup
                                                                                            : e == "Blindfolding"
                                                                                                ? blindfolding
                                                                                                : e == "Bondage"
                                                                                                    ? bondage
                                                                                                    : e == "Butt Stuff"
                                                                                                        ? buttstuff
                                                                                                        : kinky,
                                                        color: AppColors.white,
                                                        width: 15,
                                                        height: 15),
                                                  ),
                                                  label: Text(
                                                    e.toString(),
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppColors.white,
                                                        fontFamily:
                                                            "Poppins-Regular"),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.chipCircle,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                ))
                                            .toList()
                                        : selectedIndex != index
                                            ? cravesHalf
                                                .map((e) => Chip(
                                                      labelPadding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.chipColor,
                                                        child: Image.asset(
                                                            e == "Casual Dating"
                                                                ? casualdating
                                                                : e == "No String Attached"
                                                                    ? nostring1
                                                                    : e == "In Person"
                                                                        ? inperson
                                                                        : e == "Sexting"
                                                                            ? sexting2
                                                                            : e == "Kinky"
                                                                                ? kinky
                                                                                : e == "Vanilla"
                                                                                    ? vanilla
                                                                                    : e == "Submissive"
                                                                                        ? submissive
                                                                                        : e == "Dominance"
                                                                                            ? dominance
                                                                                            : e == "Dress Up"
                                                                                                ? dressup
                                                                                                : e == "Blindfolding"
                                                                                                    ? blindfolding
                                                                                                    : e == "Bondage"
                                                                                                        ? bondage
                                                                                                        : e == "Butt Stuff"
                                                                                                            ? buttstuff
                                                                                                            : kinky,
                                                            color: AppColors.white,
                                                            width: 15,
                                                            height: 15),
                                                      ),
                                                      label: Text(
                                                        e.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color:
                                                                AppColors.white,
                                                            fontFamily:
                                                                "Poppins-Regular"),
                                                      ),
                                                      backgroundColor:
                                                          AppColors.chipCircle,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                    ))
                                                .toList()
                                            : craves
                                                .map((e) => Chip(
                                                      labelPadding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      avatar: CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.chipColor,
                                                        child: Image.asset(
                                                            e == "Casual Dating"
                                                                ? casualdating
                                                                : e == "No String Attached"
                                                                    ? nostring1
                                                                    : e == "In Person"
                                                                        ? inperson
                                                                        : e == "Sexting"
                                                                            ? sexting2
                                                                            : e == "Kinky"
                                                                                ? kinky
                                                                                : e == "Vanilla"
                                                                                    ? vanilla
                                                                                    : e == "Submissive"
                                                                                        ? submissive
                                                                                        : e == "Dominance"
                                                                                            ? dominance
                                                                                            : e == "Dress Up"
                                                                                                ? dressup
                                                                                                : e == "Blindfolding"
                                                                                                    ? blindfolding
                                                                                                    : e == "Bondage"
                                                                                                        ? bondage
                                                                                                        : e == "Butt Stuff"
                                                                                                            ? buttstuff
                                                                                                            : kinky,
                                                            color: AppColors.white,
                                                            width: 15,
                                                            height: 15),
                                                      ),
                                                      label: Text(
                                                        e.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color:
                                                                AppColors.white,
                                                            fontFamily:
                                                                "Poppins-Regular"),
                                                      ),
                                                      backgroundColor:
                                                          AppColors.chipCircle,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                    ))
                                                .toList()),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(AppColors.redcolor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: const BorderSide(
                                                        color: Colors.red)))),
                                        onPressed: () {
                                          if (mounted) {
                                            setState(() {
                                              selectedIndex = index;
                                              viewMore = !viewMore;
                                            });
                                          }
                                        },
                                        child: text(
                                            context,
                                            selectedIndex == index && viewMore == true
                                                ? viewMoreButton
                                                : selectedIndex == index && viewMore == false
                                                    ? "View less"
                                                    : viewMoreButton,
                                            12.sp,
                                            color: Colors.white,
                                            fontFamily: "Poppins-Medium")),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        );
                      },
                    )),
        ));
  }

  likeUser(name, image, id) async {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    User? user = _auth.currentUser;

    await firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("likes")
        .doc(user!.uid.toString())
        .set({
      'name': name.toString(),
      'imageUrl': image.toString(),
      'likedId': user.uid.toString()
    }).then((text) {
      ToastUtils.showCustomToast(context, "User Liked", Colors.green);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  blockUser(name, image, id) async {
    User? user = _auth.currentUser;

    await firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("blocked_By")
        .doc(user!.uid.toString())
        .set({
      'name': name.toString(),
      'imageUrl': image.toString(),
      'blockedId': user.uid.toString()
    }).then((text) {
      ToastUtils.showCustomToast(context, "User Blocked", Colors.green);
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }).catchError((e) {});

    if (mounted) {
      setState(() {
        loading = false;
        Navigator.pop(context);
        isLoad = true;
        getData();
        getDataalluserexcepcurrent();
      });
    }
  }

  reportUser(name, image, id, message) async {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    var idreport = next.toInt().toString();
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("reports").doc(idreport).set({
      'reportedName': name.toString(),
      'reportedImageUrl': image.toString(),
      'reportedId': id.toString(),
      'reportedBy': user!.uid.toString(),
      'message': message,
      'report_id': idreport,
    }).then((text) {
      ToastUtils.showCustomToast(context, "User Reported", Colors.green);
      if (mounted) {
        setState(() {
          feedLoad = false;
        });
      }
      Navigator.pop(context);
    }).catchError((e) {
      if (mounted) {
        setState(() {
          feedLoad = false;
        });
      }
    });
  }

  Future<bool> isItems(String uid) async {
    CollectionReference collectionReference =
        firebaseFirestore.collection("users").doc(uid).collection("likes");
    QuerySnapshot querySnapshot = await collectionReference.get();
    return querySnapshot.docs.isNotEmpty;
  }

  isReport(String uid, String name, String imgUrl) async {
    await firebaseFirestore
        .collection('reports')
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.size == 0) {
        print("0");
        reportUser(name.toString(), imgUrl.toString(), uid.toString(),
            reportController.text.toString());
      } else {
        //check if already reported
        //getall data

        getallreports(uid, name, imgUrl);
      }
    });
  }

  getallreports(String reportId, String name, String imgurl) async {
    print("getallme hun bae");
    String uid = _auth.currentUser!.uid;
    //bool notfound = false;
    if (mounted) {
      setState(() {
        feedLoad = false;
      });
    }
    print("invalue");
    await firebaseFirestore
        .collection('reports')
        .where("reportedId", isEqualTo: reportId)
        .where("reportedBy", isEqualTo: uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        Navigator.pop(context);
        ToastUtils.showCustomToast(context, "Already Reported", Colors.red);
      } else if (value.docs.isEmpty) {
        reportUser(name, imgurl, reportId, reportController.text.toString());
      }
    });

    // QuerySnapshot querySnapshot =
    //     await firebaseFirestore.collection("reports").get();
    // for (int i = 0; i < querySnapshot.docs.length; i++) {
    //   if (reportId == querySnapshot.docs[i]["reportedId"] &&
    //       uid == querySnapshot.docs[i]["reportedBy"]) {
    //     // Navigator.pop(context);
    //     ToastUtils.showCustomToast(context, "Already Reported", Colors.red);
    //   } else {
    //     print("nae hoa  match bae");
    //     reportUser(name, imgurl, reportId, reportController.text.toString());
    //   }
    // }
  }

  Future<bool> ismatched(String uid) async {
    CollectionReference collectionReference =
        firebaseFirestore.collection("users").doc(uid).collection("blocked_By");
    QuerySnapshot querySnapshot = await collectionReference.get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isBlocked(String uid) async {
    CollectionReference collectionReference =
        firebaseFirestore.collection("users").doc(uid).collection("blocked_By");
    QuerySnapshot querySnapshot = await collectionReference.get();
    return querySnapshot.docs.isNotEmpty;
  }

  getlikedIds(String id) async {
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("likes")
        .doc(user!.uid)
        .get()
        .then((value) {
      print(value.data()!.length);
      if (value.data()!.isNotEmpty) {
        ToastUtils.showCustomToast(context, "Already Liked", Colors.green);
      } else {
        likeUser(name.toString(), photoUrl[0].toString(), id);
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  getBocksIds(String id) async {
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("blocked_By")
        .doc(user!.uid)
        .get()
        .then((value) {
      print(value.data()!.length);
      if (value.data()!.isNotEmpty) {
        Navigator.pop(context);
        ToastUtils.showCustomToast(
            context, "Already Blocked", AppColors.redcolor);
      } else {
        blockUser(name.toString(), photoUrl[0].toString(), id);
      }
    }).catchError((e) {
      log(e.toString());
    });
  }


  Future<bool> testing(String uid) async {
    CollectionReference collectionReference =
        firebaseFirestore.collection("users").doc(uid).collection("blocked_By");
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(_auth.currentUser!.uid).get();
    return documentSnapshot.exists;
  }
}
