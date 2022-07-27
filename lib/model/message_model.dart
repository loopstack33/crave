class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  int? odermsg;
  bool? seen;
  DateTime? createdon;
  String? type;
  String? timer;

  MessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.seen,
    this.odermsg,
    this.createdon,
    this.type,
    this.timer,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    odermsg = map["odermsg"];
    createdon = map["createdon"].toDate();
    type = map["type"];
    timer = map['timer'];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "odermsg": odermsg,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "type": type,
      "timer": timer,
    };
  }
}
