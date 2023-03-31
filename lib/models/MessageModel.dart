class MessageModel {
  String? eventId;
  String? from;
  String? message;
  String? profPic;

  MessageModel({
    this.eventId,
    this.from,
    this.message,
    this.profPic,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    from = json['from'];
    message = json['message'];
    profPic = json['profPic'];
  }

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "from": from,
        "message": message,
        "profPic": profPic,
      };
}
