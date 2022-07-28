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
  int? order;
  String? dateTime;
  String? roomcreator;
  String? targetId;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.roomcreator,
      this.lastMessage,
      this.read,
      this.timeStamp,
      this.count,
      this.idFrom,
      this.order,
      this.idTo,
      this.dateTime,
      this.targetId,
      this.paid});

  ChatRoomModel.fromMap(Map<dynamic, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    read = map["read"];
    order = map["order"];
    timeStamp = map["time"];
    count = map["count"];
    idFrom = map["idFrom"];
    idTo = map["idTo"];
    paid = map["paid"];
    dateTime = map["dateTime"];
    roomcreator = map["roomcreator"];
    targetId = map["targetId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "read": read,
      "time": timeStamp,
      "count": count,
      "order": order,
      "idFrom": idFrom,
      "idTo": idTo,
      "paid": paid,
      "dateTime": dateTime,
      "roomcreator": roomcreator,
      "targetId": targetId
    };
  }
}
