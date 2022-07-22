// ignore_for_file: use_build_context_synchronously

import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/utils/color_constant.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import '../../../../../../config/agora_config.dart';
import '../../../../../../model/call.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({Key? key,required this.channelId,
    required this.call,
    required this.isGroupChat,}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsapp-clone-rrr.herokuapp.com';


  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Center(child: CircularProgressIndicator(),)
          : SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: client!),
            AgoraVideoButtons(
              client: client!,
              disconnectButtonChild: IconButton(
                onPressed: () async {
                  await client!.engine.leaveChannel();
                  endCall(widget.call.callerId, widget.call.receiverId, context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void endCall(String callerId, String receiverId, BuildContext context,) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      await firebaseFirestore.collection('call').doc(callerId).delete();
      await firebaseFirestore.collection('call').doc(receiverId).delete();
    } catch (e) {
      ToastUtils.showCustomToast(context, e.toString(),AppColors.redcolor);
    }
  }
}

