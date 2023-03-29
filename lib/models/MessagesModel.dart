class MessageModel {
  String? eventId;
  String? from;
  String? message;

  MessageModel({
    this.eventId,
    this.from,
    this.message,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    from = json['from'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "from": from,
        "message": message,
      };
}
