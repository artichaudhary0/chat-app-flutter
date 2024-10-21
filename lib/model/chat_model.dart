class ChatModel {
  String msg, type, status;
  DateTime time;

  ChatModel(this.time, this.msg, this.type, this.status);

  factory ChatModel.fromMap(Map data) => ChatModel(
        DateTime.fromMicrosecondsSinceEpoch(
          int.parse(
            data["time"],
          ),
        ),
        data["msg"],
        data["type"],
        data["status"],
      );

  Map<String, dynamic> get toMap => {
        'time': time.microsecondsSinceEpoch.toString(),
        'msg': msg,
        "type": type,
        "status": status,
      };
}
