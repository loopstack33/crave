import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/model/messageModel.dart';
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
  int tempStart = 0;
  String result = "  00:00:00";
  bool timeup = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? comp, fromDb;
  String targetUserId = "";
  String chatRoomMaker = "";
  String targetCountry = "";
  String currentCountry = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
  //targetCountry diff

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

          targetUserId = value.docs[0]["targetId"];
          chatRoomMaker = value.docs[0]["roomcreator"];

          fromDb = DateTime.parse(value.docs[0]["dateTime"]);
          DateTime onedayaheadtime = fromDb!.add(const Duration(hours: 24));
          Duration diff = onedayaheadtime.difference(DateTime.now());

          _start = int.parse(diff.inSeconds.toString());
        });
      }
      if (_start < 0 || _start == 0) {
        setState(() {
          timeup = true;
        });
      } else {
        if (isPaid == false) {
          getCountries();
        } else {}
      }
    });
  }

  getCountries() async {
    if (_auth.currentUser!.uid != targetUserId) {
      log("im creator");
      await firebaseFirestore
          .collection('users')
          .doc(targetUserId)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            targetCountry = value.data()!["country"];
          });
        }
      });

      await firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            currentCountry = value.data()!["country"];
          });
        }
      });
      startTimerCreator();
    } else {
      log("im not creator");
      await firebaseFirestore
          .collection('users')
          .doc(chatRoomMaker)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            targetCountry = value.data()!["country"];
          });
        }
      });

      await firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            currentCountry = value.data()!["country"];
          });
        }
      });
      startTimer();
    }
  }

//im creator
  void startTimerCreator() {
    log("creator");
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

  //timerstarts
  void startTimer() {
    log("start");
    if (targetCountry == currentCountry) {
      log("same country");
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_start > 0) {
              _start--;
              h = _start ~/ 3600;
              m = ((_start - h! * 3600)) ~/ 60;
              s = _start - (h! * 3600) - (m! * 60);
              String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

              String minuteLeft =
                  m.toString().length < 2 ? "0$m" : m.toString();

              String secondsLeft =
                  s.toString().length < 2 ? "0$s" : s.toString();

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
    } else if (targetCountry != currentCountry) {
      log("diff country");
      log(targetCountry.toString());
      if (targetCountry == "United States") {
        log("this");
        setState(() {
          _start = _start + 32400;
        });
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              if (_start > 0) {
                _start--;
                h = _start ~/ 3600;
                m = ((_start - h! * 3600)) ~/ 60;
                s = _start - (h! * 3600) - (m! * 60);
                String hourLeft =
                    h.toString().length < 2 ? "0$h" : h.toString();

                String minuteLeft =
                    m.toString().length < 2 ? "0$m" : m.toString();

                String secondsLeft =
                    s.toString().length < 2 ? "0$s" : s.toString();

                result = "$hourLeft:$minuteLeft:$secondsLeft";
              } else {
                timeup = true;
                timer.cancel();
              }
            });
          }
        });
      } else if (targetCountry == "Pakistan") {
        log("that");
        setState(() {
          _start = _start - 32400;
        });
      }
    }
    log(_start.toString());
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
