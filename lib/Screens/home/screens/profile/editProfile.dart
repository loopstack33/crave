// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_button.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:crave/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _ProfileState();
}

class _ProfileState extends State<EditProfile> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  File? _image, _image1, _image2;
  bool isLoading = false;
  String? downloadURL;
  String? downloadURL1;
  String? downloadURL2;
  bool clearPic1 = false;
  bool clearPic = false;
  bool clearPic2 = false;
  final imagepicker = ImagePicker();
  List<CompanyEdit>? _companies;
  late List<String> _filters;
  late List<String> picsList;
  int craveCounter = 0;

  var val1 = [];
  var val2 = [];
  var val3 = [];
  TextEditingController controllerBio = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String id = '';
  List<dynamic> photoUrl = [];
  List<dynamic> craves = [];
  String name = 'Name';
  String age = 'Age';
  String country = 'Country';
  String bio = 'Bio';
  String pic1url = "";
  String pic2url = "";
  String pic3url = "";
  File? avatarImageFile;
  String? uid;

  @override
  void initState() {
    super.initState();

    uid = _auth.currentUser!.uid;
    _filters = <String>[];
    picsList = <String>[];
    _companies = <CompanyEdit>[
      CompanyEdit('Casual Dating', false, casualDating1),
      CompanyEdit('No String Attached', false, nostring),
      CompanyEdit('In Person', false, inperson1),
      CompanyEdit('Sexting', false, sexting),
      CompanyEdit('Kinky', false, kinky1),
      CompanyEdit('Vanilla', false, vanilla1),
      CompanyEdit('Submissive', false, submissive1),
      CompanyEdit('Dominance', false, dominance1),
      CompanyEdit('Dress Up', false, dressup1),
      CompanyEdit('Blindfolding', false, blindfolding1),
      CompanyEdit('Bondage', false, bondage1),
      CompanyEdit('Roleplay', false, roleplay1),
      CompanyEdit('Feet Stuff', false, feetstuf1),
      CompanyEdit('Golden Showers', false, shower1),
      CompanyEdit('Dirty Talk', false, dirtytalk1),
      CompanyEdit('Cuddling', false, cuddling1)
    ];

    getData();
  }

  getData() async {
    await _firestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        //
        id = value.data()!["uid"];
        photoUrl = value.data()!["imageUrl"];
        craves = value.data()!["craves"];
        name = value.data()!["name"];
        bio = value.data()!["bio"];
        country = value.data()!["country"];
        age = value.data()!["age"];
        isLoading = false;
        if (photoUrl.length == 1) {
          pic1url = photoUrl[0];
          pic2url = "";
          pic3url = "";
          clearPic = true;
          clearPic1 = false;
          clearPic2 = false;
          val1.add(pic1url);
        } else if (photoUrl.length == 2) {
          pic1url = photoUrl[0];
          pic2url = photoUrl[1];
          pic3url = "";
          clearPic1 = true;
          clearPic = true;
          clearPic2 = false;
          val1.add(pic1url);
          val2.add(pic2url);
        } else if (photoUrl.length == 3) {
          pic1url = photoUrl[0];
          pic2url = photoUrl[1];
          pic3url = photoUrl[2];
          clearPic = true;
          clearPic1 = true;

          clearPic2 = true;
          val1.add(pic1url);
          val2.add(pic2url);
          val3.add(pic3url);
        }

        craveCounter = craves.length;
        log(craves.toString());
        
      });
      controllerBio = TextEditingController(text: bio);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.white,
        title: text(context, "EditProfile", 24.sp,
            color: AppColors.black,
            boldText: FontWeight.w500,
            fontFamily: "Poppins-Medium"),
        centerTitle: true,
      ),
      body: ProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(context, "Profile Images", 16.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Roboto-Medium"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (pic1url == "") {
                                imagePickermethod(1);
                              }
                            },
                            child: Container(
                              width: 100.w,
                              height: 154.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: pic1url == "" || clearPic == false
                                        ? const AssetImage(addpic)
                                        : _image != null
                                            ? FileImage(_image!)
                                                as ImageProvider
                                            : NetworkImage(pic1url)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          if (clearPic == true) ...[
                            Positioned(
                              left: 65,
                              child: InkWell(
                                onTap: () {
                                  if (mounted) {
                                    if (pic1url != "") {
                                      setState(() {
                                        var collection = FirebaseFirestore
                                            .instance
                                            .collection('users');
                                        collection.doc(uid).update({
                                          'imageUrl':
                                              FieldValue.arrayRemove(val1),
                                        });
                                        getData();
                                      });
                                    }
                                  } else if (pic1url == "checked") {
                                    _image = null;
                                    clearPic = false;
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    deletePic,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (pic2url == "") {
                                imagePickermethod(2);
                              }
                            },
                            child: Container(
                              width: 100.w,
                              height: 154.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: pic2url == "" || clearPic1 == false
                                        ? const AssetImage(addpic)
                                        : _image1 != null
                                            ? FileImage(_image1!)
                                                as ImageProvider
                                            : NetworkImage(pic2url)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          if (clearPic1 == true) ...[
                            Positioned(
                              left: 65,
                              child: InkWell(
                                onTap: () {
                                  if (mounted) {
                                    if (pic2url != "") {
                                      setState(() {
                                        var collection = FirebaseFirestore
                                            .instance
                                            .collection('users');
                                        collection.doc(uid).update({
                                          'imageUrl':
                                              FieldValue.arrayRemove(val2),
                                        });
                                        getData();
                                      });
                                    }
                                  } else if (pic2url == "checked") {
                                    _image1 = null;
                                    clearPic1 = false;
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    deletePic,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (pic3url == "") {
                                imagePickermethod(3);
                              }
                            },
                            child: Container(
                              width: 100.w,
                              height: 154.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: pic3url == "" || clearPic2 == false
                                        ? const AssetImage(addpic)
                                        : _image2 != null
                                            ? FileImage(_image2!)
                                                as ImageProvider
                                            : NetworkImage(pic3url)),
                                // : NetworkImage(pic3url)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          if (clearPic2 == true) ...[
                            Positioned(
                              left: 65,
                              child: InkWell(
                                onTap: () {
                                  if (mounted) {
                                    if (pic3url != "") {
                                      setState(() {
                                        var collection = FirebaseFirestore
                                            .instance
                                            .collection('users');
                                        collection.doc(uid).update({
                                          'imageUrl':
                                              FieldValue.arrayRemove(val3),
                                        });
                                        getData();
                                      });
                                    }
                                  } else if (pic3url == "checked") {
                                    _image2 = null;
                                    clearPic2 = false;
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset(
                                    deletePic,
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),

                  //
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(context, "$name, $age", 28.sp,
                          color: const Color(0xff606060),
                          boldText: FontWeight.w500,
                          fontFamily: "Poppins-SemiBold"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        locationicon,
                        width: 16.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 5.w),
                      text(context, country, 14.sp,
                          color: const Color(0xff606060),
                          boldText: FontWeight.w500,
                          fontFamily: "Poppins-Medium"),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  text(context, "ABOUT ME", 16.sp,
                      color: AppColors.black,
                      boldText: FontWeight.w500,
                      fontFamily: "Poppins-SemiBold"),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    // height: 136.h,

                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff636363),
                              fontFamily: "Poppins-Regular"),
                          controller: controllerBio,
                          onSaved: (String? value) {
                            controllerBio.text = value!;
                          },
                          maxLines: 2,
                          maxLength: 100,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 0, bottom: 5, top: 5, right: 5),
                              hintText: "About Me",
                              hintStyle: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 14.sp,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w400)),
                        )),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      width: 335.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: text(
                                context, "Selected  ${craveCounter}/3", 14.sp,
                                color: AppColors.black,
                                boldText: FontWeight.w400,
                                fontFamily: "Poppins-Medium"),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          //chipping
                          Column(
                            children: <Widget>[
                              Wrap(
                                children: companyWidgets.toList(),
                              ),
                              // Text('Selected: ${_filters.join(', ')}'),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  DefaultButton(
                      text: "Save",
                      press: () {
                        // if(_image == null){
                        //   ToastUtils.showCustomToast(context, "Please select at least one image.", AppColors.redcolor);
                        // }
                        // else if(textController.text.isEmpty){
                        //   ToastUtils.showCustomToast(context, "Please add your bio", AppColors.redcolor);
                        // }
                        if (_filters.isEmpty) {
                          ToastUtils.showCustomToast(context,
                              "Please select your craves", AppColors.redcolor);
                        } else {
                          postDetailsToFirestore(context);
                        }
                        // else {
                        //   if(mounted){
                        //     setState(() {
                        //       isLoading = true;
                        //     });
                        //   }
                        //   postDetailsToFirestore(context);
                        // }
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Iterable<Widget> get companyWidgets sync* {
    for (CompanyEdit company in _companies!) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          showCheckmark: false,
          avatar: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white,
                  Color(0xffFF6767),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              company.iconname,
              color:
                  company.status == false ? AppColors.redcolor : Colors.white,
              width: 8.w,
              height: 9.h,
              fit: BoxFit.contain,
            ),
          ),
          backgroundColor:
              company.status == false ? Color(0xffFAFAFA) : AppColors.redcolor,
          label: text(context, company.name, 12.sp,
              color: company.status == false ? Colors.black : AppColors.white,
              boldText: FontWeight.w400,
              fontFamily: "Poppins-Regular"),
          selected: _filters.contains(company.name),
          selectedColor:
              company.status == false ? Colors.white : AppColors.redcolor,
          onSelected: (bool selected) {
            if (mounted) {
              setState(() {
                if (selected) {
                  if (_filters.length < 3) {
                    craveCounter = _filters.length + 1;
                    _filters.add(company.name);
                    company.status = true;
                  } else {}
                } else {
                  company.status = false;

                  _filters.removeWhere((String name) {
                    return name == company.name;
                  });
                  craveCounter--;
                }
              });
            }
          },
        ),
      );
    }
  }

  Future imagePickermethod(int check) async {
    final pick = await imagepicker.pickImage(source: ImageSource.gallery);

    if (pick != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pick.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: AppColors.redcolor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        if (mounted) {
          setState(() {
            if (check == 1) {
              pic1url = "checked";
              _image = File(croppedFile.path);
              clearPic = true;
            } else if (check == 2) {
              pic2url = "checked";
              _image1 = File(croppedFile.path);
              clearPic1 = true;
            } else {
              pic3url = "checked";
              _image2 = File(croppedFile.path);
              clearPic2 = true;
            }
          });
        }
      }
    } else {}
  }

  void postDetailsToFirestore(BuildContext context) async {
    if (_image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child(_image!.path.split('/').last);
      await ref.putFile(_image!);
      downloadURL = await ref.getDownloadURL();
      picsList.add(downloadURL!);
    }
    if (_image1 != null) {
      Reference ref1 =
          FirebaseStorage.instance.ref().child(_image1!.path.split('/').last);
      await ref1.putFile(_image1!);
      downloadURL1 = await ref1.getDownloadURL();
      picsList.add(downloadURL1!);
    }
    if (_image2 != null) {
      Reference ref2 =
          FirebaseStorage.instance.ref().child(_image2!.path.split('/').last);
      await ref2.putFile(_image2!);
      downloadURL2 = await ref2.getDownloadURL();
      picsList.add(downloadURL2!);
    }

    final auth = FirebaseAuth.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User? user = auth.currentUser;

    await firebaseFirestore.collection("users").doc(user!.uid).update({
      'bio': controllerBio.text,
      'imageUrl': FieldValue.arrayUnion(picsList),
      'craves': FieldValue.arrayUnion(_filters),
      // 'steps':'6',
    }).then((text) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        // AppRoutes.push(
        //     context, PageTransitionType.fade, const CreatingProfileScreen());
        preferences.setString("logStatus", "true");
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class CompanyEdit {
  CompanyEdit(this.name, this.status, this.iconname);
  final String name;
  bool status;
  final String iconname;
}
