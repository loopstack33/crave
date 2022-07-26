// ignore_for_file: file_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/Screens/splash/creatingProfile.dart';
import 'package:crave/utils/app_routes.dart';
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
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? _image, _image1, _image2;
  bool isLoading = false;
  String? downloadURL;
  String? downloadURL1;
  String? downloadURL2;
  bool clearPic1 = false;
  bool clearPic = false;
  bool clearPic2 = false;
  final imagepicker = ImagePicker();
  late List<Company> _companies;
  late List<String> _filters;
  late List<String> picsList;
  int craveCounter = 0;
  final textController = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _filters = <String>[];
    picsList = <String>[];
    _companies = <Company>[
      Company('Casual Dating', false, casualDating1),
      Company('No String Attached', false, nostring),
      Company('In Person', false, inperson1),
      Company('Sexting', false, sexting),
      Company('Kinky', false, kinky1),
      Company('Vanilla', false, vanilla1),
      Company('Submissive', false, submissive1),
      Company('Dominance', false, dominance1),
      Company('Dress Up', false, dressup1),
      Company('Blindfolding', false, blindfolding1),
      Company('Bondage', false, bondage1),
      Company('Roleplay', false, roleplay1),
      Company('Feet Stuff', false, feetstuf1),
      Company('Golden Showers', false, shower1),
      Company('Dirty Talk', false, dirtytalk1),
      Company('Cuddling', false, cuddling1)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.redcolor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.white,
        title: text(context, "Create Profile", 24.sp,
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
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
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
                      SizedBox(
                        width: 102.w,
                        height: 154.h,
                        child: InkWell(
                          onTap: () {
                            imagePickermethod(1);
                          },
                          child: _image == null || clearPic == false
                              ? Image.asset(addpic)
                              : Image.file(_image!),
                        ),
                      ),
                      if (clearPic == true) ...[
                        Positioned(
                          left: 65,
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _image = null;
                                  clearPic = false;
                                });
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
                      SizedBox(
                        width: 102.w,
                        height: 154.h,
                        child: InkWell(
                          onTap: () {
                            imagePickermethod(2);
                          },
                          child: _image1 == null || clearPic1 == false
                              ? Image.asset(addpic)
                              : Image.file(_image1!),
                        ),
                      ),
                      if (clearPic1 == true) ...[
                        Positioned(
                          left: 65,
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _image1 = null;
                                  clearPic1 = false;
                                });
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
                      SizedBox(
                        width: 102.w,
                        height: 154.h,
                        child: InkWell(
                          onTap: () {
                            imagePickermethod(3);
                          },
                          child: _image2 == null || clearPic2 == false
                              ? Image.asset(addpic)
                              : Image.file(_image2!),
                        ),
                      ),
                      if (clearPic2 == true) ...[
                        Positioned(
                          left: 65,
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _image2 = null;
                                  clearPic2 = false;
                                });
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
              SizedBox(
                height: 10.h,
              ),
              text(context, "About Me", 16.sp,
                  color: const Color(0xff191919),
                  boldText: FontWeight.w500,
                  fontFamily: "Roboto-Medium"),
              SizedBox(
                height: 10.h,
              ),
              Container(
                // height: 136.h,
                // margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextFormField(
                    onSaved: (String? value) {
                      textController.text = value!;
                    },
                    style: const TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 14,
                        color: Color(0xff636363)),
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    autocorrect: true,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'Enter Some Text',
                      hintStyle: TextStyle(
                          fontFamily: "Poppins-Regular", fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: text(context, "Selected  $craveCounter/3", 14.sp,
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
                  DefaultButton(
                      text: "Confirm",
                      press: () {
                        if (_image == null) {
                          ToastUtils.showCustomToast(
                              context,
                              "Please select at least one image.",
                              AppColors.redcolor);
                        } else if (textController.text.isEmpty) {
                          ToastUtils.showCustomToast(context,
                              "Please add your bio", AppColors.redcolor);
                        } else if (_filters.isEmpty) {
                          ToastUtils.showCustomToast(context,
                              "Please select your craves", AppColors.redcolor);
                        } else {
                          if (mounted) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          postDetailsToFirestore(context);
                        }
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
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
      'bio': textController.text,
      'imageUrl': FieldValue.arrayUnion(picsList),
      'craves': FieldValue.arrayUnion(_filters),
      'steps': '6',
    }).then((text) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        AppRoutes.push(context, PageTransitionType.rightToLeft,
            const CreatingProfileScreen());
        preferences.setString("logStatus", "true");
        preferences.setString("uid", user.uid.toString());
      }
    }).catchError((e) {});
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Iterable<Widget> get companyWidgets sync* {
    for (Company company in _companies) {
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
          backgroundColor: company.status == false
              ? const Color(0xffFAFAFA)
              : AppColors.redcolor,
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

                if (_filters.length < 3) {
                } else {}
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
              _image = File(croppedFile.path);
              clearPic = true;
            } else if (check == 2) {
              _image1 = File(croppedFile.path);
              clearPic1 = true;
            } else {
              _image2 = File(croppedFile.path);
              clearPic2 = true;
            }
          });
        }
      }
    } else {}
  }
}

class Company {
  Company(this.name, this.status, this.iconname);
  final String name;
  bool status;
  final String iconname;
}
