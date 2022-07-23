class ChatRoomModel {
  String? chatroomid;
  Map<dynamic, dynamic>? participants;
  String? lastMessage;
  bool? read;
  String? timeStamp;
  String? idFrom;
  String? idTo;
  int? count;
  bool? paid;
  String? dateTime;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.read,
      this.timeStamp,
      this.count,
      this.idFrom,
      this.idTo,
      this.dateTime,
      this.paid});

  ChatRoomModel.fromMap(Map<dynamic, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    read = map["read"];
    timeStamp = map["time"];
    count = map["count"];
    idFrom = map["idFrom"];
    idTo = map["idTo"];
    paid = map["paid"];
     dateTime = map["dateTime"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "read": read,
      "time": timeStamp,
      "count": count,
      "idFrom": idFrom,
      "idTo": idTo,
      "paid": paid,
      "dateTime":dateTime
    };
  }
}
