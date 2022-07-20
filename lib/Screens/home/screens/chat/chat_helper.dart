import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  
  static Future getUserModelById(String uid) async {
    //log(' getUserModelById uid: $uid');
    var data;
    DocumentSnapshot docSnap =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
     // log('Userdata: $data');
    } else {
      log("users null");
    }

    return data;
  }

  static Future getFromAllDatabase(String uid) async {
    var data;
    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
    //  log('Userdata: $data');
    } else {
      log("users null");

    }

    return data;
  }

  static void updateUserStatus(uid, String status) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("users").doc(uid).update({
      'status': status.toString(),
    }).then((value) {
      log("Status Update Done");
    });
  }
}
