class ToDoModel{
  String id,title;
  bool status;
  int dTime;
  ToDoModel(this.id,this.title,this.status, this.dTime);

  factory ToDoModel.fromMap (Map data)=>ToDoModel(data["id"] ?? "0000", data["title"]??"undefined", data["status"]??false, data["d_time"]??111);

  Map<String , dynamic> get toMap=>{
    'id':id,
    'title': title,
    'status' : status,
    'd_time' :dTime,
  };

}