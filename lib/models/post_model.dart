class UserModel{
  String? byid;
  String? purpose;
  String? description;
  String? time;

  UserModel({this.byid, this.purpose, this.time, this.description,});
  UserModel.fromJson(Map<String,dynamic> json){
    byid = json['byid'];
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
