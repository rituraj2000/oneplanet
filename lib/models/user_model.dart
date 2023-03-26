class UserModel{
  String? id;
  String? name;
  String? photo;
  String? points;
  String? globalrank;
  String? drives;
  String? lable;

  UserModel({this.id, this.name, this.photo, this.points, this.globalrank, this.drives, this.lable});
  UserModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    points = json['points'];
    globalrank = json['globalrank'];
    drives = json['drives'];
    lable = json['lable'];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['points'] = points;
    data['globalrank'] = globalrank;
    data['drives'] = drives;
    data['lable'] = lable;
    return data;
  }
}
