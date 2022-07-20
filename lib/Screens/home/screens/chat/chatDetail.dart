// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../model/chat_room_model.dart';
import '../../../../model/userModel.dart';
import '../../../../utils/color_constant.dart';
import '../../../../utils/images.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../model/message_model.dart';
import 'dart:io';

import '../../../../services/fcm_services.dart';
import '../../../../widgets/custom_toast.dart';



class ChatDetailPage extends StatefulWidget{
  final UsersModel targetUser;
  final ChatRoomModel chatRoom;
  final UsersModel userModel;
  final status;
  ChatDetailPage({Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.status,}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;

  Timer? _timer;
  int time = 0;
  var timerValue = 0;

  void countTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerValue++;

    });
  }

  //late AudioPlayer _audioPlayer;
  late String _filePath;

  // final record = Record();
  int? selectedIndex;

  double progress = 0.0;

  TextEditingController msgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FocusNode focusNode = FocusNode();
  bool isShowSticker = false;

  //final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

//  CountDownController timerController = new CountDownController();

  @override
  void initState() {
    super.initState();
    updateStatus();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    //  BackButtonInterceptor.add(myInterceptor);
    selectedIndex = -1;
    // _audioPlayer = AudioPlayer();
    // _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // timerController = CountDownController();
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  void updateStatus() async {

    if (widget.chatRoom.idFrom != auth.currentUser!.uid) {
      final DocumentReference documentReference =
      _firestore.collection('chatrooms').doc(widget.chatRoom.chatroomid);
      documentReference.update(<String, dynamic>{'read': true, 'count': 0});
      widget.chatRoom.count = 0;
    } else {}
  }

  @override
  void dispose() {

    // Provider.of<ChatProvider>(context, listen: false).audioPlayer.dispose();
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    //Provider.of<ChatProvider>(context, listen: false).timer!.cancel();
  }

  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  File? imageFile;
  String imageUrl = "";
  String videoUrl = "";

  // PlatformFile? file;
  UploadTask? uploadTask;

  Future getCameraImage() async {
    Navigator.pop(context);
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  File? imageFile2;
  Future getImage2() async {
    Navigator.pop(context);
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
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
      sender: widget.userModel.userId.toString(),
      text: "",
      seen: false,
      type: "image",
      createdon: DateTime.now(),
      timer: timerValue.toString(),
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
        widget.chatRoom.idFrom = widget.userModel.userId;
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
            "Image File");
        if (mounted) {
          setState(() {
            isLoading = false;
            uploadTask = null;
          });
        }
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

  bool _isUpload = false;

  sendMsg(String mType, String mText) async {
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.userModel.userId.toString(),
      text: mText,
      seen: false,
      type: mType,
      createdon: DateTime.now(),
      timer: timerValue.toString(),
    );
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());
    var msgcount1 = 1;
    if (mType == "audio") {
      widget.chatRoom.lastMessage = "audioFile";
      widget.chatRoom.read = false;
      widget.chatRoom.idFrom = widget.userModel.userId;
      widget.chatRoom.idTo = widget.targetUser.userId;
      widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
          ? 0
          : widget.chatRoom.count! + msgcount1;
      widget.chatRoom.timeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    else {
      widget.chatRoom.lastMessage = msgController.text;
      widget.chatRoom.read = false;
      widget.chatRoom.idFrom = widget.userModel.userId;
      widget.chatRoom.idTo = widget.targetUser.userId;
      widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
          ? 0
          : widget.chatRoom.count! + msgcount1;
      widget.chatRoom.timeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
    }

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .set(widget.chatRoom.toMap());

    // FCMServices.sendFCM(
    //     widget.targetUser.userToken,
    //     widget.targetUser.userId.toString(),
    //     widget.targetUser.userName.toString(),
    //     widget.chatRoom.lastMessage.toString());
    msgController.clear();
    timerValue = 0;
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    if (mounted) {
      setState(() {
        emojiShowing = !emojiShowing;
        //isShowSticker = !isShowSticker;
      });
    }
  }

  bool isRecording = false;

  Future<bool> onBackPress() {
    if (isShowSticker) {
      if (mounted) {
        setState(() {
          isShowSticker = false;
        });
      }
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  bool play = false;
  double _amplitude = 1;

  bool playTimer = false;
  int endText = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding:const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon:const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.redcolor,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: ClipOval(
                      child: Image.network(
                        widget.targetUser.imgUrl[0].toString(),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (
                            BuildContext context,
                            Object exception,
                            StackTrace? stackTrace,
                            ) {
                          return Text(
                            'Oops!! An error occurred. 😢',
                            style: TextStyle(fontSize: 16.sp),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.targetUser.userName,style: TextStyle( fontFamily: 'Poppins-Medium',fontSize: 13.sp),),
                        Row(children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.status.toString() == "online"
                                    ? Colors.lightGreenAccent
                                    : Colors.grey),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            widget.status.toString() == "online"
                                ? "Active Now"
                                : "Offline",style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.sp)

                          ),
                        ]),
                       // Text("active now",style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 10.sp),),
                        Text("00:15:31",style: TextStyle(fontFamily: 'Poppins-SemiBold', fontSize: 10.sp),),
                      ],
                    ),
                  ),
                  Image.asset(video,width: 30.w,height: 30.h,),
                  SizedBox(width: 10.w),
                  Icon(FontAwesomeIcons.ellipsisVertical,color: AppColors.black,size: 25.sp,),
                ],
              ),
            ),
          ),
        ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding:const EdgeInsets.only(left: 20,right: 20),
                height: 30.h,
                width: double.infinity,
                color: Colors.black.withOpacity(0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("This chat will self destruct soon.",style: TextStyle(color: AppColors.shadeLight,fontSize: 11.sp,fontFamily: 'Poppins-Regular'),),
                    Text("turn off chat timer",style: TextStyle(color: AppColors.shadeLight,fontSize: 11.sp,fontFamily: 'Poppins-Regular'))

                  ],

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 55.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                      snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                          // Text
                          return /*currentMessage.type == "text"
                              ? Row(
                            mainAxisAlignment:
                            (currentMessage.sender ==
                                widget.userModel.userId)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                (currentMessage.sender ==
                                    widget.userModel.userId)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(
                                              text:
                                              currentMessage
                                                  .text))
                                          .then((value) =>
                                          ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                              const Duration(
                                                  seconds:
                                                  1),
                                              backgroundColor:
                                              AppColors
                                                  .redcolor,
                                              content: Text(
                                                'Message Copied',
                                                style: TextStyle(
                                                    fontFamily:
                                                    'Poppins',
                                                    fontSize:
                                                    12.sp,
                                                    color: Colors
                                                        .white),
                                              ),
                                            ),
                                          ));
                                    },
                                    child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 300.w,
                                            minWidth: 50.w),
                                        //width:MediaQuery.of(context).size.width * 0.7,
                                        margin:
                                        const EdgeInsets.symmetric(
                                          vertical: 0,
                                        ),
                                        padding:
                                        const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: currentMessage
                                            .sender ==
                                            widget.userModel.userId
                                            ? BoxDecoration(
                                          color: AppColors
                                              .redcolor,
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10.r),
                                        )
                                            : BoxDecoration(
                                          color: AppColors
                                              .redcolor,
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10.r),
                                        ),
                                        child: Text(
                                          currentMessage.text
                                              .toString(),

                                        )),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    DateFormat.jm().format(
                                        currentMessage.createdon!),

                                  ),
                                  SizedBox(
                                    height: 80.h,
                                  ),
                                ],
                              ),
                            ],
                          )
                          */
                          currentMessage.type == "text" ?
                          Container(
                            padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                            child: Align(
                              alignment: ( (currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft),
                              child: Column(
                                crossAxisAlignment:  (currentMessage.sender == widget.userModel.userId)? CrossAxisAlignment.end: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: (currentMessage.sender == widget.userModel.userId)?
                                      BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomLeft: Radius.circular(15.r)):BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r),bottomRight: Radius.circular(15.r)),
                                      color: ( (currentMessage.sender == widget.userModel.userId)?AppColors.chatColor:Colors.grey.shade200),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(currentMessage.text!, style: TextStyle(fontSize: 15.sp,fontFamily: 'Poppins-Regular',color: AppColors.shadeText),),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:  (currentMessage.sender == widget.userModel.userId)?  MainAxisAlignment.end:MainAxisAlignment.start,
                                    children: [
                                      Text(DateFormat.jm().format(currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                                      SizedBox(width: 5.w),
                                      Image.asset(tick,width: 15.w,height: 15.h,color:currentMessage.seen.toString() =="true"?null:AppColors.lightGrey ,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ):
                          // Image
                          currentMessage.type == "image" ?
                          // Audio
                          Container(
                            padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                            child: Align(
                              alignment: ((currentMessage.sender == widget.userModel.userId)?Alignment.topRight:Alignment.topLeft),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: Image.asset(currentMessage.text!,width: 185.w,height: 126.h,)),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:  (currentMessage.sender == widget.userModel.userId)?
                                    MainAxisAlignment.end:  MainAxisAlignment.start,
                                    children: [
                                      Text(DateFormat.jm().format(currentMessage.createdon!),style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 10.sp,color:const Color(0xFF606060).withOpacity(0.6)),),
                                      SizedBox(width: 5.w),
                                      Image.asset(tick,width: 15.w,height: 15.h,color:currentMessage.seen.toString()=="true"?null:AppColors.lightGrey ,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ):
                          currentMessage.type == "audio" ?
                         const Text("Hello")
                          /* : currentMessage.type == "image"
                                    ? Row(
                                  mainAxisAlignment:
                                  (currentMessage.sender ==
                                      widget.userModel.uid)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      (currentMessage.sender ==
                                          widget
                                              .userModel.uid)
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          child: OutlinedButton(
                                            child: Material(
                                              child:
                                              currentMessage
                                                  .text !=
                                                  ""
                                                  ? Image.network(
                                                currentMessage
                                                    .text!,
                                                loadingBuilder: (BuildContext
                                                context,
                                                    Widget
                                                    child,
                                                    ImageChunkEvent?
                                                    loadingProgress) {
                                                  if (loadingProgress ==
                                                      null)
                                                    return child;
                                                  return Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      color:
                                                      AppColors.blackColor,
                                                      borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(8.r),
                                                      ),
                                                    ),
                                                    width:
                                                    200.w,
                                                    height:
                                                    200.h,
                                                    child:
                                                    Center(
                                                      child:
                                                      CircularProgressIndicator(
                                                        color:
                                                        AppColors.darkBlueColor,
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder:
                                                    (context,
                                                    object,
                                                    stackTrace) {
                                                  return Material(
                                                    child: Image
                                                        .asset(
                                                      'Images/chat/img_not_available.jpeg',
                                                      width:
                                                      200.w,
                                                      height:
                                                      200.h,
                                                      fit: BoxFit
                                                          .cover,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                      Radius.circular(
                                                          8.r),
                                                    ),
                                                    clipBehavior:
                                                    Clip.hardEdge,
                                                  );
                                                },
                                                width:
                                                200.w,
                                                height:
                                                200.h,
                                                fit: BoxFit
                                                    .cover,
                                              )
                                                  : Center(
                                                child: StreamBuilder<
                                                    TaskSnapshot>(
                                                    stream: uploadTask
                                                        ?.snapshotEvents,
                                                    builder:
                                                        (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .hasData) {
                                                        final data =
                                                            snapshot.data;
                                                        double
                                                        progress =
                                                        (data!.bytesTransferred / data.totalBytes);
                                                        return SizedBox(
                                                          width: 200.w,
                                                          height: 200.h,
                                                          child: Stack(
                                                            fit: StackFit.expand,
                                                            children: [
                                                              SizedBox(
                                                                width: 60.w,
                                                                height: 60.h,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(70.0),
                                                                  child: CircularProgressIndicator(value: progress, color: AppColors.darkBlueColor, backgroundColor: Colors.grey),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  '${(100 * progress).roundToDouble()} %',
                                                                  style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 15.sp),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return SizedBox();
                                                      }
                                                    }),
                                              ),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      8)),
                                              clipBehavior:
                                              Clip.hardEdge,
                                            ),
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .unfocus();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullPhotoPage(
                                                        url:
                                                        currentMessage
                                                            .text!,
                                                      ),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty
                                                    .all<EdgeInsets>(
                                                    EdgeInsets
                                                        .all(0))),
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: 10, right: 10),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          DateFormat.jm().format(
                                              currentMessage
                                                  .createdon!),
                                          style: GoogleFonts.rubik(
                                            fontSize: 10.sp,
                                            color: AppColors.lgColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                                // Audio
                                    : currentMessage.type == "audio"
                                    ? audioMessage(
                                    currentMessage, index, prov)*/
                          : const SizedBox.shrink();

                        },
                      );


                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occurred! Please check your internet connection."),
                      );
                    } else {
                      return const Center(
                          child: Text(
                            "Say hi to your new friend",
                          )
                      );
                    }
                  } else {
                    return const Center();
                  }
                },
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding:const EdgeInsets.only(left: 20,bottom: 10,top: 10,right: 20),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
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
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            suffixIcon:/*msgController.text.isNotEmpty?*/
                            GestureDetector(
                              onTap: (){
                                if (_formKey.currentState!.validate()) {
                                  sendMsg("text", msgController.text.trim().toString());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.paperPlane,size: 25.sp,color: AppColors.redcolor,),
                              ),
                            ),/*:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(mic),
                            ),*/
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
            ),

          ],
        ),
      ),
    );
  }

  /*
  Widget audioMessage(MessageModel currentMessage, int index, ChatProvider prov) {
    return Padding(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 10,
            left: (currentMessage.sender == widget.userModel.uid ? 64 : 10),
            right: (currentMessage.sender == widget.userModel.uid ? 10 : 64)),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentMessage.sender == widget.userModel.uid
                    ? AppColors.blueColor
                    : AppColors.lBlueColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      selectedIndex == index && play == true
                          ? Container(
                        width: 40.w,
                        height: 40.h,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.darkBlueColor2,
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (mounted) {
                              setState(() {
                                selectedIndex = index;
                                play = false;
                              });
                              // Future.delayed(const Duration(milliseconds: 500),
                              //     () {
                              //   timerController.pause();
                              // });
                            }
                          },
                        ),
                      )
                          : Container(
                        width: 40.w,
                        height: 40.h,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.darkBlueColor2,
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (mounted) {
                              setState(() {
                                play = true;
                                selectedIndex = index;
                              });
                              // Future.delayed(const Duration(milliseconds: 500),
                              //     () {
                              //   timerController.resume();
                              // });
                            }

                            audioPlayer.play(currentMessage.text!,
                                isLocal: false);

                            audioPlayer.onPlayerCompletion
                                .listen((duration) {
                              if (mounted) {
                                setState(() {
                                  play = false;
                                  selectedIndex = -1;
                                });
                              }
                            });
                          },
                        ),
                      ),
                      Image.asset(
                        "Images/News/audio bars.png",
                      ),

                      // SizedBox(
                      //   width: 5,
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     left: 5,
                      //   ),
                      //   height: 25,
                      //   child: NeonCircularTimer(
                      //       onComplete: () {
                      //         timerController.pause();
                      //       },
                      //       width: 25,
                      //       textStyle: TextStyle(
                      //         fontSize: 7,
                      //       ),
                      //       controller: timerController,
                      //       initialDuration: 0,
                      //       duration: currentMessage.text.toInt(),
                      //       strokeWidth: 5,
                      //       autoStart: false,
                      //       isTimerTextShown: true,
                      //       neumorphicEffect: true,
                      //       outerStrokeColor: Colors.grey.shade100,
                      //       innerFillGradient: LinearGradient(colors: [
                      //         Colors.greenAccent.shade200,
                      //         Colors.blueAccent.shade400
                      //       ]),
                      //       neonGradient: LinearGradient(colors: [
                      //         Colors.greenAccent.shade200,
                      //         Colors.blueAccent.shade400
                      //       ]),
                      //       strokeCap: StrokeCap.round,
                      //       innerFillColor: Colors.black12,
                      //       backgroudColor: Colors.grey.shade100,
                      //       neonColor: Colors.blue.shade900),

                      // ),
                    ],
                  ),
                  Text(
                    formatSeconds(currentMessage.timer.toInt())

                    */
  /* DateFormat.jm().format(
                        currentMessage
                            .createdon!)*/
  /*

                    ,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.jm().format(currentMessage.createdon!),
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
*/

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    if (mounted) {
      setState(() {
        _isUploading = true;
      });
    }
    try {
      Reference ref = storage.ref('audioRecords').child(
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length));
      UploadTask uploadTask = ref.putFile(File(_filePath));
      uploadTask.then((res) async {
        var audioURL = await res.ref.getDownloadURL();
        String strVal = audioURL.toString();
        await sendMsg("audio", strVal);
      });
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isRecorded = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while uploading'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }


  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  /*  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      record.stop();
      _isRecording = false;
      _isRecorded = true;
      playTimer = false;
      timerController.pause();
      var t = timerController.getTimeInSeconds();

      timerValue = t;

      print('timerValue: ${timerValue}');
    } else {
      _isRecorded = false;
      _isRecording = true;
      playTimer = true;
      print('playTimer: ${playTimer}');
      await _startRecording();

      Future.delayed(const Duration(milliseconds: 500), () {
        timerController.resume();
      });
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission = await record.hasPermission();

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      await record.start(
        path: filepath,
        bitRate: 128000, // by default
      );

      _filePath = filepath;

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }*/

  bool emojiShowing = false;

  void onTapEmojiField() {
    if (!emojiShowing) {
      if (mounted) {
        setState(() {
          emojiShowing = true;
        });
      }
    }
  }

  /*

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (emojiShowing) {
      if (mounted) {
        setState(() {
          emojiShowing = false;
        });
      }
      return true;
    } else {
      return false;
    }
  }
*/

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

  String formatSeconds(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}