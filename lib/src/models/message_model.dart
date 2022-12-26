// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  String? createdOn;
  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = map["createdOn"];
  }

  Map<String, dynamic> tojson() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdOn,
    };
  }
}
