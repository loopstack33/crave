import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../model/chat_room_model.dart';

class TimerWidget extends StatefulWidget {
  final ChatRoomModel chatRoom;
  bool isLoad;
  TimerWidget({Key? key, required this.chatRoom, required this.isLoad})
      : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int? h, m, s;
  Timer? _timer;
  int _start = 0;
  String result = "  00:00:00";
  bool timeup = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? comp, fromDb;

  @override
  void initState() {
    super.initState();
    gettingtimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  bool isPaid = false;
  //gettingtimefrom Db
  gettingtimer() async {
    await firebaseFirestore
        .collection('chatrooms')
        .where('chatroomid', isEqualTo: widget.chatRoom.chatroomid)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          isPaid = value.docs[0]["paid"];
          fromDb = DateTime.parse(value.docs[0]["dateTime"]);
          DateTime onedayaheadtime = fromDb!.add(const Duration(hours: 24));
          Duration diff = onedayaheadtime.difference(DateTime.now());

          _start = int.parse(diff.inSeconds.toString());
          widget.isLoad = false;
        });
      }
      if (_start < 0 || _start == 0) {
        setState(() {
          timeup = true;
        });
      } else {
        if (isPaid == false) {
          startTimer();
        } else {}
      }
    });
  }

  //timerstarts
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_start > 0) {
            _start--;
            h = _start ~/ 3600;
            m = ((_start - h! * 3600)) ~/ 60;
            s = _start - (h! * 3600) - (m! * 60);
            String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

            String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

            String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

            result = "$hourLeft:$minuteLeft:$secondsLeft";
          } else {
            timeup = true;
            timer.cancel();
          }
        });
      }
    });
    if (mounted) {
      setState(() {
        widget.isLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isPaid == false
        ? Text(
            timeup == false ? result : "  00:00:00",
            style: TextStyle(fontFamily: 'Poppins-SemiBold', fontSize: 12.sp),
          )
        : const SizedBox();
  }
}
