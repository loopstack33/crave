// ignore_for_file: empty_catches, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String userId;
  String userToken;
  String userName;
  String phoneNumber;
  String status;
  String birthday;
  String gender;
  String genes;
  String bio;
  String package;
  List craves;
  List imgUrl;
  String showName;
  List likedBy;

  UsersModel(
      {required this.userName,
      required this.bio,
      required this.phoneNumber,
      required this.status,
      required this.userId,
      required this.gender,
      required this.userToken,
      required this.birthday,
      required this.package,
      required this.genes,
      required this.craves,
      required this.imgUrl,
      required this.likedBy,
      required this.showName});

  Map<String, dynamic> toJson() => {
        'uid': userId,
        'phone': phoneNumber,
        'name': userName,
        'deviceToken': userToken,
        'status': status,
        'gender': gender,
        'birthday': birthday,
        'genes': genes,
        'bio': bio,
        'package': package,
        'craves': craves,
        'imageUrl': imgUrl,
        'showName': showName,
        'likedBy': likedBy,
      };

  factory UsersModel.fromDocument(DocumentSnapshot doc) {
    String uid = "";
    String deviceToken = "";
    String uname = "";
    String status = "";
    String gender = "";
    String phone = "";
    String birthday = "";
    String genes = "";
    String bio = "";
    String package = "";
    List craves = [];
    List imageUrl = [];
    String showName = "";
    List likedBy = [];

    try {
      likedBy = doc.get("likedBy");
    } catch (e) {}

    try {
      showName = doc.get("showName");
    } catch (e) {}
    try {
      uid = doc.get("uid");
    } catch (e) {}

    try {
      deviceToken = doc.get("deviceToken");
    } catch (e) {}
    try {
      uname = doc.get("name");
    } catch (e) {}
    try {
      genes = doc.get("genes");
    } catch (e) {}
    try {
      birthday = doc.get("birthday");
    } catch (e) {}

    try {
      phone = doc.get("phone");
    } catch (e) {}

    try {
      bio = doc.get("bio");
    } catch (e) {}

    try {
      status = doc.get("status");
    } catch (e) {}

    try {
      gender = doc.get("gender");
    } catch (e) {}

    try {
      package = doc.get("package");
    } catch (e) {}
    try {
      craves = doc.get("craves");
    } catch (e) {}
    try {
      imageUrl = doc.get("imageUrl");
    } catch (e) {}

    return UsersModel(
        userId: uid,
        phoneNumber: phone,
        userName: uname,
        userToken: deviceToken,
        status: status,
        gender: gender,
        birthday: birthday,
        genes: genes,
        bio: bio,
        package: package,
        craves: craves,
        showName: showName,
        likedBy: likedBy,
        imgUrl: imageUrl);
  }
}
