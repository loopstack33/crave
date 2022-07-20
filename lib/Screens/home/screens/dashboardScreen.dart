// ignore_for_file: file_names
import 'dart:developer';
import 'dart:ui';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/home/screens/settings.dart';
import 'package:crave/utils/app_routes.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/confirm_dialouge.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../widgets/custom_toast.dart';

// This is the type used by the popup menu below.
enum Menu { BlockForever, Report }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int selectedIndex = 0;
  List<dynamic> cravesHalf = [];

  bool viewMore = true;
  String viewMoreButton = "View More";

  @override
  void initState() {
    super.initState();
    getData();
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

  String _selectedMenu = '';
  TextEditingController reportController = TextEditingController();
  bool feedLoad = false;

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('uid', isNotEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.redcolor));
            } else {
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                  snapshot.data!.docs;
              return docs.isNotEmpty
                  ? ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        List<dynamic> craves = List.from(docs[index]['craves']);
                        cravesHalf.clear();
                        if (craves.length > 3) {
                          for (int i = 0; i < 3; i++) {
                            String temp;
                            temp = craves[i].toString();
                            cravesHalf.add(temp);
                          }
                        }
                        //log(cravesHalf.toString());

                        List<dynamic> imgList =
                            List.from(docs[index]['imageUrl']);

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
                                                                                  reportUser(docs[index]["name"].toString(), docs[index]["imageUrl"][0].toString(), docs[index]['uid'].toString(), reportController.text.toString());
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
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    location,
                                                    width: 15.w,
                                                    height: 15.h,
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  text(
                                                      context,
                                                      docs[index]["country"],
                                                      15.sp,
                                                      color: AppColors.white,
                                                      fontFamily:
                                                          'Poppins-Regular'),
                                                ],
                                              ),
                                              text(context, docs[index]['name'],
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
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return ConfirmDialog(
                                                                    message:
                                                                        "For chating you have to pay \$1.99",
                                                                    press:
                                                                        () {});
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
                                                            // if (mounted) {
                                                            //   setState(() {
                                                            //     selectedIndex = index;
                                                            //     loading = true;
                                                            //   });
                                                            // }

                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(docs[index]['uid']
                                                                  .toString())
                                                                  .collection(
                                                                      "likes")
                                                                  .get()
                                                                  .then(
                                                                      (value) {
                                                                // likeUser(
                                                                //     name
                                                                //         .toString(),
                                                                //     photoUrl[0]
                                                                //         .toString(),
                                                                //     docs[index][
                                                                //             'uid']
                                                                //         .toString());
                                                                        log(value.docs[index]["likedId"].toString());
                                                                        log(_auth.currentUser!.uid.toString());
                                                              /*  if (value.docs[index]["likedId"] == _auth.currentUser!.uid.toString()) {
                                                                  log("HEEEEEEE");
                                                                  if (mounted) {
                                                                    setState(
                                                                            () {
                                                                          loading =
                                                                          false;
                                                                        });
                                                                  }
                                                                  ToastUtils.showCustomToast(
                                                                      context,
                                                                      "Already liked this user",
                                                                      AppColors
                                                                          .redcolor);
                                                                }
                                                                else {
                                                                  likeUser(docs[index]['name'].toString(),
                                                                      docs[index]['imageUrl'][0].toString(),
                                                                      docs[index]['uid'].toString());
                                                                  log("HEEEEEERRRRRRRE");

                                                                }*/
                                                              });
                                                            } catch (e) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });
                                                              }
                                                              debugPrint(
                                                                  e.toString());
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
                                  Image.asset(
                                    femaleGirl,
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 10.w),
                                  Image.asset(
                                    gene1,
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              text(context, docs[index]["bio"], 12.sp,
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
                                        : craves
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
                    )
                  : const Center(
                      child: Text("Nothing to show",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)));
            }
          },
        ),
      ),
    );
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
        .doc(next.toInt().toString())
        .set({
      'name': name.toString(),
      'imageUrl': image.toString(),
      'likedId': user!.uid.toString()
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

  reportUser(name, image, id, message) async {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    User? user = _auth.currentUser;

    await firebaseFirestore
        .collection("reports")
        .doc(next.toInt().toString())
        .set({
      'reportedName': name.toString(),
      'reportedImageUrl': image.toString(),
      'reportedId': id.toString(),
      'reportedBy': user!.uid.toString(),
      'message': message,
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
}
