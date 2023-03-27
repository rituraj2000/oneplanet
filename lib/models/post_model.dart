class PostModel{
  String? byid;
  String? purpose;
  String? description;
  String? time;

  PostModel({this.byid, this.purpose, this.time, this.description,});
  PostModel.fromJson(Map<String,dynamic> json){
    byid = json['byid'];
    purpose = json['purpose'];
    description = json['description'];
    time = json['time'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['byid'] = byid;
    data['purpose'] = purpose;
    data['description'] = description;
    data['time'] = time;
    return data;
  }
}
