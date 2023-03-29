class PostModel{
  String? userID;
  String? eventID;
  String? title;
  String? description;
  String? location;
  String? lat;
  String? lon;
  String? date;
  String? eventTime;
  String? type;
  String? photo;


  PostModel({this.userID, this.eventID, this.title, this.description, this.location, this.lat, this.lon, this.date, this.eventTime, this.type, this.photo});
  PostModel.fromJson(Map<String,dynamic> json){
    userID = json['userID'];
    title = json['title'];
    description = json['description'];
    lat = json['lat'];
    lon = json['lon'];
    eventID = json['eventID'];
    date = json['date'];
    eventTime = json['eventtime'];
    type = json['type'];
    location = json['location'];
    photo = json['photo'];
  }

}
