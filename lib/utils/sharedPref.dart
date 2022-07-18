// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
 

  saveGender(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("gender", value);
  }

  getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("gender");
  }
}