// ignore_for_file: file_names, use_build_context_synchronously, import_of_legacy_library_into_null_safe
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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pay/pay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool alreadyLiked = false;
  bool isLoad = false;
  bool colorheart = false;
  bool loading = false;
  String country = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int selectedIndex = 0;
  List<dynamic> cravesHalf = [];
  List<dynamic> currentUserlist = [];
  bool viewMore = true;
  bool boolLike = false;
  String viewMoreButton = "View More";
  UsersModel? allUsers;
  List<UsersModel> allUserexceptblocked = [];
  List<UsersModel> allUserexceptblockedChat = [];
  List<UsersModel> temp = [];
  String? currentGender;
  String? location;
  // Location location = new Location();

  // bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;
  // LocationData? _locationData;
  @override
  void initState() {
    super.initState();

    getData();

    getDataalluserexcepcurrent();
  }

  Map<Permission, PermissionStatus>? statuses;
  getPermissions() async {
    log("inPerssion");
    statuses = await [
      Permission.location,
    ].request();

    getUserLoc();
  }

  Position? position;
  getUserLoc() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      await _getAddress(position.latitude, position.longitude);
    }).catchError((e) {
      log(e.toString());
    });
  }

  var addr;
  // Method for retrieving the address
  _getAddress(var ulat, var ulng) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(ulat, ulng);
      Placemark place = placemarks[0];
      addr =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      log(place.country.toString());
      preferences.setString("country", place.country.toString());
      sendtoFirebase(place.country.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  sendtoFirebase(String location) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .update({
          'gender': location,
        })
        .then((text) {})
        .catchError((e) {});
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
        currentUserlist.add(id.toString());
        currentGender = value.data()!["gender"];
        location = value.data()!["country"];
      });
    });
    log(location.toString());
    if (location == "" || location == null || location!.isEmpty) {
      getPermissions();
    }
  }

  getDataalluserexcepcurrent() async {
    allUserexceptblockedChat.clear();
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

    log(allUserexceptblocked.length.toString());
    for (int i = 0; i < allUserexceptblocked.length; i++) {
      bool checkblock1 = await testingChat(
          _auth.currentUser!.uid, allUserexceptblocked[i].userId);
      if (checkblock1 == false) {
        allUserexceptblockedChat.add(allUserexceptblocked[i]);
      }
    }

    if (mounted) {
      setState(() {
        // isLoad = false;
      });
    }
    log(allUserexceptblockedChat.length.toString());
    //  temp.clear();
    temp = allUserexceptblockedChat;
  }

  String _selectedMenu = '';
  TextEditingController reportController = TextEditingController();
  bool feedLoad = false;

  static ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> assignChatRoom(
      BuildContext context, token, userName, targetID, userID) async {
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

      ToastUtils.showCustomToast(
          context, "Chat room already assigned", Colors.red);
    } else {
      log("ChatRoom Not Available");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: const Uuid().v1(),
        lastMessage: "",
        read: false,
        idFrom: "",
        order: 0,
        targetId: targetID,
        roomcreator: _auth.currentUser!.uid,
        paid: false,
        idTo: "",
        dateTime: DateTime.now().toString(),
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
      // AppRoutes.push(
      //     context,
      //     PageTransitionType.fade,
      //     UserChatList(
      //       isDash: true,
      //     ));
      FCMServices.sendFCM(token, targetID.toString(), name.toString(),
          "Want's to chat with you.");
      ToastUtils.showCustomToast(
          context, "ChatRoom Assigned Success", Colors.green);
    }

    return chatRoom;
  }

  Future<void> _refresh() {
    getData();
    getDataalluserexcepcurrent();
    return Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
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
        ),
        body: ProgressHUD(
            inAsyncCall: isLoad,
            opacity: 0.1,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: allUserexceptblockedChat.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          itemCount: allUserexceptblockedChat.length,
                          itemBuilder: (context, index) {
                            List<dynamic> craves = List.from(
                                allUserexceptblockedChat[index].craves);
                            cravesHalf.clear();
                            if (craves.length > 5) {
                              for (int i = 0; i < craves.length / 2; i++) {
                                String temp;
                                temp = craves[i].toString();
                                cravesHalf.add(temp);
                              }
                            } else if (craves.length == 1) {
                              cravesHalf.add(craves[0].toString());
                            } else if (craves.length == 2) {
                              cravesHalf.add(craves[0].toString());
                              cravesHalf.add(craves[1].toString());
                            } else if (craves.length == 3) {
                              cravesHalf.add(craves[0].toString());
                              cravesHalf.add(craves[1].toString());
                              cravesHalf.add(craves[2].toString());
                            } else if (craves.length == 4) {
                              cravesHalf.add(craves[0].toString());
                              cravesHalf.add(craves[1].toString());
                              cravesHalf.add(craves[2].toString());
                              cravesHalf.add(craves[3].toString());
                            }

                            List<dynamic> imgList = List.from(
                                allUserexceptblockedChat[index].imgUrl);

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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16.r)),
                                                    child: Image.network(
                                                      item,
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
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                          _selectedMenu =
                                                              item.name;
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
                                                                        BorderRadius.circular(
                                                                            20.r)),
                                                                elevation: 10,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .white,
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
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                                                                              gradient: LinearGradient(
                                                                                begin: Alignment.topCenter,
                                                                                end: Alignment.bottomCenter,
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
                                                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                onTap: () async {
                                                                                  blockUser(name.toString(), photoUrl[0].toString(), allUserexceptblockedChat[index].userId.toString());
                                                                                },
                                                                                child: Container(
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
                                                                                onTap: () async {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
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
                                                                        BorderRadius.circular(
                                                                            20.r)),
                                                                elevation: 10,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .white,
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
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                                                                              gradient: LinearGradient(
                                                                                begin: Alignment.topCenter,
                                                                                end: Alignment.bottomCenter,
                                                                                colors: [
                                                                                  AppColors.redcolor.withOpacity(0.35),
                                                                                  AppColors.redcolor
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    "Report User",
                                                                                    style: TextStyle(fontSize: 22.sp, color: AppColors.white, fontFamily: 'Poppins-Regular', fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment.centerRight,
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Icon(
                                                                                      FontAwesomeIcons.multiply,
                                                                                      color: AppColors.white,
                                                                                      size: 25.sp,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.all(10),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: const Color(0xFFB7B7B7),
                                                                                width: 1, //
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(12.0.r),
                                                                            ),
                                                                            child:
                                                                                TextFormField(
                                                                              controller: reportController,
                                                                              maxLength: 400,
                                                                              maxLines: 2,
                                                                              style: TextStyle(fontSize: 18.sp, color: const Color(0xFF676060), fontFamily: 'Poppins', fontWeight: FontWeight.w300),
                                                                              textAlignVertical: TextAlignVertical.center,
                                                                              decoration: InputDecoration(
                                                                                hintText: "Write your report message here...",
                                                                                hintStyle: TextStyle(fontSize: 18.sp, color: AppColors.textColor, fontWeight: FontWeight.w300, fontFamily: 'Poppins'),
                                                                                fillColor: const Color(0xFFFFFFFF),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(12.0.r),
                                                                                  borderSide: const BorderSide(
                                                                                    color: AppColors.white,
                                                                                  ),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(12.0.r),
                                                                                  borderSide: BorderSide(
                                                                                    color: AppColors.white,
                                                                                    width: 1.0.r,
                                                                                  ),
                                                                                ),
                                                                                errorBorder: OutlineInputBorder(
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
                                                                                      isReport(allUserexceptblockedChat[index].userId.toString(), allUserexceptblockedChat[index].userName, allUserexceptblockedChat[index].imgUrl[0].toString());
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
                                                            value: Menu
                                                                .BlockForever,
                                                            child: Text(
                                                              'Block Forever',
                                                              style: TextStyle(
                                                                  color: const Color(
                                                                      0xFF2F2F48),
                                                                  fontFamily:
                                                                      'Poppins-Regular',
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ),
                                                          PopupMenuItem<Menu>(
                                                            value: Menu.Report,
                                                            child: Text(
                                                                'Report',
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
                                                  if (allUserexceptblockedChat[
                                                              index]
                                                          .showName
                                                          .toString() ==
                                                      "true") ...[
                                                    text(
                                                        context,
                                                        allUserexceptblockedChat[
                                                                index]
                                                            .userName,
                                                        22.sp,
                                                        color: AppColors.white,
                                                        fontFamily:
                                                            'Poppins-Medium'),
                                                  ]
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 10,
                                                          sigmaY: 10),
                                                      child: Container(
                                                          color: AppColors
                                                              .containerborder
                                                              .withOpacity(0.6),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (currentGender ==
                                                                  "Man") {
                                                                const paymentItems =
                                                                    [
                                                                  PaymentItem(
                                                                    label:
                                                                        'Crave ChatPay',
                                                                    amount:
                                                                        '1.99',
                                                                    status: PaymentItemStatus
                                                                        .final_price,
                                                                  )
                                                                ];
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Dialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        elevation:
                                                                            0.0,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              515.w,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(14.r),
                                                                          ),
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                                                                                  width: 515.w,
                                                                                  decoration: BoxDecoration(
                                                                                    color: AppColors.redcolor,
                                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(14.r), topRight: Radius.circular(14.r)),
                                                                                  ),
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      "Action Required",
                                                                                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins-Medium', fontSize: 22.sp),
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
                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins-Medium', fontSize: 20.sp),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: 10.h),
                                                                                Text(
                                                                                  "For chatting without liking pay 1.99 \$.",
                                                                                  style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black, fontFamily: 'Poppins-Regular', fontSize: 18.sp),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10.h,
                                                                                ),
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
                                                                                      onPaymentResult: (data) {
                                                                                        print(data);
                                                                                        assignChatRoom(
                                                                                          context,
                                                                                          allUserexceptblocked[index].userToken,
                                                                                          allUserexceptblocked[index].userName,
                                                                                          allUserexceptblocked[index].userId,
                                                                                          _auth.currentUser!.uid,
                                                                                        );
                                                                                      },
                                                                                      onError: (data) {
                                                                                        ToastUtils.showCustomToast(context, data.toString(), Colors.red);
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
                                                                                      onPaymentResult: (data) {
                                                                                        print(data);
                                                                                        assignChatRoom(
                                                                                          context,
                                                                                          allUserexceptblocked[index].userName,
                                                                                          allUserexceptblocked[index].userToken,
                                                                                          allUserexceptblocked[index].userId,
                                                                                          _auth.currentUser!.uid,
                                                                                        );
                                                                                      },
                                                                                      onError: (data) {
                                                                                        ToastUtils.showCustomToast(context, data.toString(), Colors.red);
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
                                                              } else {
                                                                assignChatRoom(
                                                                  context,
                                                                  allUserexceptblocked[
                                                                          index]
                                                                      .userName,
                                                                  allUserexceptblocked[
                                                                          index]
                                                                      .userToken,
                                                                  allUserexceptblocked[
                                                                          index]
                                                                      .userId,
                                                                  _auth
                                                                      .currentUser!
                                                                      .uid,
                                                                );
                                                              }
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
                                                        BorderRadius.circular(
                                                            15.r),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 10,
                                                          sigmaY: 10),
                                                      child: Container(
                                                          color: AppColors
                                                              .containerborder
                                                              .withOpacity(0.6),
                                                          child: IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              onPressed:
                                                                  () async {
                                                                bool exits = await isItems(
                                                                    allUserexceptblockedChat[
                                                                            index]
                                                                        .userId
                                                                        .toString());
                                                                log(exits
                                                                    .toString());

                                                                if (exits) {
                                                                  getlikedIds(allUserexceptblockedChat[
                                                                          index]
                                                                      .userId
                                                                      .toString());
                                                                  log(allUserexceptblockedChat[
                                                                          index]
                                                                      .userId
                                                                      .toString());
                                                                } else {
                                                                  likeUser(
                                                                      name
                                                                          .toString(),
                                                                      photoUrl[
                                                                              0]
                                                                          .toString(),
                                                                      allUserexceptblockedChat[
                                                                              index]
                                                                          .userId
                                                                          .toString());
                                                                }
                                                              },
                                                              icon: selectedIndex ==
                                                                      index
                                                                  ? boolLike
                                                                      ? SizedBox(
                                                                          width: 25
                                                                              .w,
                                                                          height: 25
                                                                              .h,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                AppColors.redcolor,
                                                                            strokeWidth:
                                                                                2.0.w,
                                                                          ))
                                                                      : Icon(
                                                                          FontAwesomeIcons
                                                                              .solidHeart,
                                                                          size:
                                                                              28.sp,
                                                                          color: (allUserexceptblockedChat[index].likedBy.any((item) => currentUserlist.contains(item)))
                                                                              ? AppColors.redcolor
                                                                              : colorheart == true
                                                                                  ? AppColors.redcolor
                                                                                  : AppColors.white,
                                                                        )
                                                                  : Icon(
                                                                      FontAwesomeIcons
                                                                          .solidHeart,
                                                                      size:
                                                                          28.sp,
                                                                      color: (allUserexceptblockedChat[index].likedBy.any((item) => currentUserlist.contains(
                                                                              item)))
                                                                          ? AppColors
                                                                              .redcolor
                                                                          : AppColors
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
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Image.asset(
                                        allUserexceptblockedChat[index]
                                                    .gender ==
                                                "Man"
                                            ? male
                                            : allUserexceptblockedChat[index]
                                                        .gender ==
                                                    "Woman"
                                                ? female
                                                : other,
                                        color: Colors.white,
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        allUserexceptblockedChat[index]
                                                    .gender ==
                                                "Man"
                                            ? "Man"
                                            : allUserexceptblockedChat[index]
                                                        .gender ==
                                                    "Woman"
                                                ? "Woman"
                                                : "Others",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Image.asset(
                                        allUserexceptblockedChat[index].genes ==
                                                "Hetero"
                                            ? hetero
                                            : allUserexceptblockedChat[index]
                                                        .genes ==
                                                    "Lesbian"
                                                ? lesbian
                                                : allUserexceptblockedChat[
                                                                index]
                                                            .genes ==
                                                        "Gay"
                                                    ? gay
                                                    : bisexual,
                                        color: Colors.white,
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Text(
                                        allUserexceptblockedChat[index].genes ==
                                                "Hetero"
                                            ? "Hetero"
                                            : allUserexceptblockedChat[index]
                                                        .genes ==
                                                    "Lesbian"
                                                ? "Lesbian"
                                                : allUserexceptblockedChat[
                                                                index]
                                                            .genes ==
                                                        "Gay"
                                                    ? "gay"
                                                    : "bisexual",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  text(
                                      context,
                                      allUserexceptblockedChat[index].bio,
                                      12.sp,
                                      color: AppColors.white,
                                      fontFamily: 'Poppins-Regular'),
                                  SizedBox(height: 10.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                        spacing:
                                            8.0, // gap between adjacent chips
                                        runSpacing: 4.0, // gap between lines
                                        children: selectedIndex == index &&
                                                viewMore == true
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
                                            : selectedIndex != index
                                                ? cravesHalf
                                                    .map((e) => Chip(
                                                          labelPadding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          avatar: CircleAvatar(
                                                            backgroundColor:
                                                                AppColors
                                                                    .chipColor,
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
                                                                color: AppColors
                                                                    .white,
                                                                fontFamily:
                                                                    "Poppins-Regular"),
                                                          ),
                                                          backgroundColor:
                                                              AppColors
                                                                  .chipCircle,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                        ))
                                                    .toList()
                                                : craves
                                                    .map((e) => Chip(
                                                          labelPadding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          avatar: CircleAvatar(
                                                            backgroundColor:
                                                                AppColors
                                                                    .chipColor,
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
                                                                color: AppColors
                                                                    .white,
                                                                fontFamily:
                                                                    "Poppins-Regular"),
                                                          ),
                                                          backgroundColor:
                                                              AppColors
                                                                  .chipCircle,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                        ))
                                                    .toList()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        AppColors.redcolor),
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
                        ),
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Lottie.asset("assets/raw/doubleheart.json"),
                          ),
                        ],
                      )))));
  }

  likeUser(name, image, id) async {
    User? user = _auth.currentUser;
    setState(() {
      boolLike = true;
    });

    await firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("likes")
        .doc(user!.uid.toString())
        .set({
      'name': name.toString(),
      'imageUrl': image.toString(),
      'likedId': user.uid.toString(),
      'deviceToken': user.uid.toString()
    }).then((text) async {
      saveDatainLikedBy(id);

      ToastUtils.showCustomToast(context, "User Liked", Colors.green);
    }).catchError((e) {});
  }

  saveDatainLikedBy(String id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(id)
        .update({'likedBy': FieldValue.arrayUnion(currentUserlist)})
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));

    setState(() {
      boolLike = false;
      colorheart = true;
    });
    //getDataalluserexcepcurrent();
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
        // isLoad = true;
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
      ToastUtils.showCustomToast(context, "User Reported", Colors.red);
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

  getlikedIds(String givenid) async {
    User? user = _auth.currentUser;

    await firebaseFirestore
        .collection("users")
        .doc(givenid)
        .collection("likes")
        .where("likedId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      log(value.docs.length.toString());
      if (value.docs.length == 1) {
        if (mounted) {
          setState(() {
            alreadyLiked = true;
          });
        }

        ToastUtils.showCustomToast(context, "Already Liked", Colors.red);
      } else {
        likeUser(name.toString(), photoUrl[0].toString(), givenid);
      }
    }).catchError((e) {
      log("here");
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

  Future<bool> testingChat(targetID, userID) async {
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
    return snapshot.docs.isNotEmpty;
  }

  Future<bool> alreadyLikedUser(targetID) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(targetID)
        .collection("likes")
        .where(
          "likedId",
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
