import 'dart:developer';
import 'package:crave/Screens/splash/splash.dart';
import 'package:crave/services/fcm_services.dart';
import 'package:crave/services/local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  await LocalNotificationsService.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FCMServices.fcmGetTokenandSubscribe('crave');
  fcmListen();
  runApp(const MyApp());
}

Future<void> _messageHandler(RemoteMessage event) async {
  log('targetId: ${event.data['id']}');
  log('userId: ${FirebaseAuth.instance.currentUser?.uid}');

  if (event.data['id'].toString() == FirebaseAuth.instance.currentUser?.uid.toString()) {

    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }
  else {}
  log("Handling a background message: ${event.messageId}");
}

fcmListen() async {
  // var sfID = await AuthServices.getTraderID();
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    log('targetId: ${event.data['id']}');
     log('userId: ${FirebaseAuth.instance.currentUser?.uid}');
    if (event.data['id'].toString() == FirebaseAuth.instance.currentUser?.uid.toString()) {
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');

      FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    } else {}

  });
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, _) {
          return const MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        });
  }
}
