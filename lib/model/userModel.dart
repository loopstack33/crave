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



  UsersModel({
    required this.userName,required this.bio,required this.phoneNumber,required this.status,required this.userId,required this.gender,required this.userToken,
  required this.birthday,required this.genes});

  Map<String, dynamic> toJson() => {
    'uid': userId,
    'phone': phoneNumber,
    'name': userName,
    'deviceToken': userToken,
    'status': status,
    'gender':gender,
    'birthday':birthday,
    'genes':genes,
    'bio': bio,
  };

  factory UsersModel.fromDocument(DocumentSnapshot doc) {
    String userId="";
    String userToken="";
    String userName="";
    String status="";
    String gender="";
    String phoneNumber="";
    String birthday="";
    String genes="";
    String bio="";


    try {
      userId = doc.get("userId");
    } catch (e) {
      print(e);
    }

    try {
      userToken = doc.get("userToken");
    }
    catch (e) {
      print(e);
    }
    try {
      userName = doc.get("userName");
    } catch (e) {
      print(e);
    }
    try {
      genes = doc.get("genes");
    } catch (e) {
      print(e);
    }
    try {
      birthday = doc.get("birthday");
    } catch (e) {
      print(e);
    }

    try {
      phoneNumber = doc.get("phoneNumber");
    } catch (e) {
      print(e);
    }

    try {
      bio = doc.get("bio");
    } catch (e) {
      print(e);
    }

    try {
      status = doc.get("status");
    } catch (e) {
      print(e);
    }

    try {
      gender = doc.get("gender");
    } catch (e) {
      print(e);
    }

    return UsersModel(
      userId: userId,
      phoneNumber: phoneNumber,
      userName: userName,
      userToken: userToken,
      status: status,
      gender:gender,
      birthday:birthday,
      genes:genes,
      bio: bio,
    );
  }
}