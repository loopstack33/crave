import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crave/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../../../../model/chat_room_model.dart';
import '../../../../../model/message_model.dart';
import '../../../../../services/fcm_services.dart';
import '../../../../../utils/color_constant.dart';
import '../../../../../utils/images.dart';
import '../../../../../widgets/custom_toast.dart';

class BottomField extends StatefulWidget {
  final UsersModel usersModel;
  final ChatRoomModel chatRoom;
  final UsersModel targetUser;

  const BottomField({Key? key,required this.usersModel,required this.chatRoom,required this.targetUser}) : super(key: key);

  @override
  State<BottomField> createState() => _BottomFieldState();
}

class _BottomFieldState extends State<BottomField> {
  TextEditingController msgController = TextEditingController();
  bool isShowSendButton = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    updateStatus();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }
  @override
  void dispose() {
    super.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async{
    if(isShowSendButton){
      if (_formKey.currentState!.validate()) {
        sendMsg("text", msgController.text.trim().toString());
      }
      if(mounted){
        setState((){
          msgController.text = '';
        });
      }
    }
    else{
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/crave_sound.aac';
      if(!isRecorderInit){
        return;
      }
      if(isRecording){
        await _soundRecorder!.stopRecorder();
        sendAudioMessage(File(path),"Audio");
      }
      else{
        await _soundRecorder!.startRecorder(toFile: path);
      }
      if(mounted){
        setState((){
          isRecording = !isRecording;
        });
      }
    }

  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding:const EdgeInsets.only(left: 20,bottom: 10,top: 10,right: 20),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (builder) => bottomSheet());
              },
              child: Image.asset(camera,width: 26.w,height: 26.h,),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.redcolor,width: 1.w)
                ),
                child: TextFormField(
                  controller: msgController,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      if(mounted) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    } else {
                      if(mounted) {
                        setState(() {
                          isShowSendButton = false;
                        });
                      }
                    }
                  },
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      suffixIcon:isShowSendButton?GestureDetector(
                        onTap: (){
                          sendTextMessage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(FontAwesomeIcons.paperPlane,size: 25.sp,color: AppColors.redcolor,),
                        ),
                      )
                          :Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: (){
                              sendTextMessage();
                            },
                            child: Image.asset(isRecording?cross:mic)),
                      )
                      ,
                      contentPadding: const EdgeInsets.only(left: 10,bottom: 10),
                      hintText: "Message...",
                      hintStyle: TextStyle(color:const Color(0xFF636363),fontFamily: 'Poppins-Regular',fontSize: 16.sp),
                      border: InputBorder.none
                  ),
                ),
              ),
            ),

          ],

        ),
      ),
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconCreation(
                  FontAwesomeIcons.image, Colors.purple, "Image", getImage2),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(
                  FontAwesomeIcons.camera, Colors.pink, "Camera", getCameraImage),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(
                  FontAwesomeIcons.video, Colors.red, "Video", selectVideo),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  bool isLoading2 = false;
  File? imageFile;
  String imageUrl = "";
  String videoUrl = "";
  String audioUrl = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UploadTask? uploadTask;
  UploadTask? uploadTask2;

  Future getCameraImage() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  File? imageFile2;
  Future getImage2() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  Future uploadImage2() async {
    String fileName = const Uuid().v1();
    int status = 1;
    MessageModel newMessage = MessageModel(
      messageid: fileName,
      sender: widget.usersModel.userId.toString(),
      text: "",
      seen: false,
      type: "image",
      createdon: DateTime.now(),
      timer: "0",
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    final path = 'imageFiles/$fileName';
    final fle = File(imageFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    if (status == 1) {
      if (mounted) {
        setState(() {
          uploadTask = ref.putFile(fle);
        });
      }
      try {
        final snap = await uploadTask!.whenComplete(() => {});
        imageUrl = await snap.ref.getDownloadURL();
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .collection('messages')
            .doc(fileName)
            .update({"text": imageUrl});

        var msgcount = 1;

        widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
            ? 0
            : widget.chatRoom.count! + msgcount;
        widget.chatRoom.read = false;
        widget.chatRoom.idFrom = widget.usersModel.userId;
        widget.chatRoom.idTo = widget.targetUser.userId;
        widget.chatRoom.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        widget.chatRoom.lastMessage = "Image File";
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());

        FCMServices.sendFCM(
            widget.targetUser.userToken,
            widget.targetUser.userId.toString(),
            widget.targetUser.userName.toString(),
            "📷 New Image Message");
        if (mounted) {
          setState(() {
            isLoading = false;
            uploadTask = null;
          });
        }
        updateStatus();
      } on FirebaseException catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
            status = 0;
            uploadTask = null;
          });
        }
        ToastUtils.showCustomToast(
            context, e.message ?? e.toString(), AppColors.redcolor);
      }
    }
  }

  Future<File?> pickVideoFromGallery(BuildContext context) async{
    File? video;
    try{
      final pickVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if(pickVideo !=null){
        video = File(pickVideo.path);
      }
    }
    catch(e){
      log("Error");
    }
    return video;
  }

  void selectVideo() async{
    Navigator.pop(context);
    File? video = await pickVideoFromGallery(context);
    if(video!=null){
      sendVideoMessage(video,"video");
    }
  }

  sendVideoMessage(File videoPath,String type) async{
    String fileName = const Uuid().v1();
    int status = 1;
    MessageModel newMessage = MessageModel(
      messageid: fileName,
      sender: widget.usersModel.userId.toString(),
      text: "",
      seen: false,
      type: type,
      createdon: DateTime.now(),
      timer: "0",
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    final path = 'videoFiles/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);

    if (status == 1) {
      if (mounted) {
        setState(() {
          uploadTask2 = ref.putFile(videoPath);
        });
      }
      try {
        final snap = await uploadTask2!.whenComplete(() => {});
        videoUrl = await snap.ref.getDownloadURL();
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .collection('messages')
            .doc(fileName)
            .update({"text": videoUrl.toString()});

        var msgcount = 1;

        widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
            ? 0
            : widget.chatRoom.count! + msgcount;
        widget.chatRoom.read = false;
        widget.chatRoom.idFrom = widget.usersModel.userId;
        widget.chatRoom.idTo = widget.targetUser.userId;
        widget.chatRoom.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        widget.chatRoom.lastMessage = "Video";
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());

        FCMServices.sendFCM(widget.targetUser.userToken, widget.targetUser.userId.toString(), widget.targetUser.userName.toString(), "📸 New Video Message");

        if (mounted) {
          setState(() {
            isLoading2 = false;
            uploadTask2 = null;
          });
        }
        updateStatus();
      } on FirebaseException catch (e) {
        if (mounted) {
          setState(() {
            isLoading2 = false;
            status = 0;
            uploadTask2 = null;
          });
        }
        ToastUtils.showCustomToast(context, e.message ?? e.toString(), AppColors.redcolor);
      }
    }
  }

  sendAudioMessage(File audioPath,String type) async{
    String fileName = const Uuid().v1();
    int status = 1;
    MessageModel newMessage = MessageModel(
      messageid: fileName,
      sender: widget.usersModel.userId.toString(),
      text: "",
      seen: false,
      type: type,
      createdon: DateTime.now(),
      timer: "0",
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    final path = 'audioFiles/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);

    if (status == 1) {
      if (mounted) {
        setState(() {
          uploadTask2 = ref.putFile(audioPath);
        });
      }
      try {
        final snap = await uploadTask2!.whenComplete(() => {});
        audioUrl = await snap.ref.getDownloadURL();
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .collection('messages')
            .doc(fileName)
            .update({"text": audioUrl.toString()});

        var msgcount = 1;

        widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
            ? 0
            : widget.chatRoom.count! + msgcount;
        widget.chatRoom.read = false;
        widget.chatRoom.idFrom = widget.usersModel.userId;
        widget.chatRoom.idTo = widget.targetUser.userId;
        widget.chatRoom.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        widget.chatRoom.lastMessage = "Audio";
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());

        FCMServices.sendFCM(
            widget.targetUser.userToken,
            widget.targetUser.userId.toString(),
            widget.targetUser.userName.toString(),
            "🎵 New Audio Message");
        if (mounted) {
          setState(() {
            isLoading2 = false;
            uploadTask2 = null;
          });
        }
        updateStatus();
      } on FirebaseException catch (e) {
        if (mounted) {
          setState(() {
            isLoading2 = false;
            status = 0;
            uploadTask2 = null;
          });
        }
        ToastUtils.showCustomToast(context, e.message ?? e.toString(), AppColors.redcolor);
      }
    }
  }

  var uuid = const Uuid();
  sendMsg(String mType, String mText) async {
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.usersModel.userId.toString(),
      text: mText,
      seen: false,
      type: mType,
      createdon: DateTime.now(),
      timer: "0",
    );
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());
    var msgcount1 = 1;
    widget.chatRoom.lastMessage = msgController.text;
    widget.chatRoom.read = false;
    widget.chatRoom.idFrom = widget.usersModel.userId;
    widget.chatRoom.idTo = widget.targetUser.userId;
    widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
        ? 0
        : widget.chatRoom.count! + msgcount1;
    widget.chatRoom.timeStamp =
        DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .set(widget.chatRoom.toMap());
    updateStatus();
    FCMServices.sendFCM(
        widget.targetUser.userToken,
        widget.targetUser.userId.toString(),
        widget.targetUser.userName.toString(),
        widget.chatRoom.lastMessage.toString());
    msgController.clear();

  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void updateStatus() async {
    if (widget.chatRoom.idFrom != auth.currentUser!.uid) {
      final DocumentReference documentReference =
      _firestore.collection('chatrooms').doc(widget.chatRoom.chatroomid);
      documentReference.update(<String, dynamic>{'read': true, 'count': 0});
      widget.chatRoom.count = 0;

      FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatRoom.chatroomid).collection("messages").get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.update({
            'seen': true,
          });
        }
      });
    } else {}
  }
}
