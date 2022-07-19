// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../model/messageModel.dart';

class FavoriteContacts extends StatefulWidget {
  const FavoriteContacts({Key? key}) : super(key: key);

  @override
  State<FavoriteContacts> createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {

  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getLikes();
    super.initState();
  }
  getLikes() async{

    await firebaseFirestore.collection("users").doc( _auth.currentUser!.uid)
        .collection("likes").get().then((value) {
      if (mounted) {
        setState(() {
        count = value.docs.length;
        });

      }

    }).catchError((e) {
      log(e.toString());
    });

  }

  int count =0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20.0),
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
                  color: AppColors.redcolor
                ),
                padding:const EdgeInsets.only(left: 3,right: 3,top: 2,bottom: 2),
                margin:const EdgeInsets.all(2),
                child: Text(count.toString(),style: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins-SemiBold',color: AppColors.white),),
              )
            ],
          ),
        ),
        SizedBox(
          height: 120.h,
          child:StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc( _auth.currentUser!.uid)
                .collection("likes")
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.redcolor));
              }

              else {
                final List<
                    QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot
                    .data!.docs;

                return docs.isNotEmpty ?
                ListView.builder(
                  shrinkWrap: true,
                  padding:const EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {},
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
                                      ImageChunkEvent? loadingProgress) {
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
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,) {
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
                              style:  TextStyle(
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
                ):
                const Center(child: Text("No Likes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
              }
            },
          ),



        ),
      ],
    );
  }
}