class MessagesResponse {
  List<Messages>? messages;

  MessagesResponse({this.messages});

  MessagesResponse.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? userId;
  String? username;
  int? roomId;
  String? text;
  String? datetime;

  Messages({this.userId, this.username, this.roomId, this.text, this.datetime});

  Messages.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    roomId = json['roomId'];
    text = json['text'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['roomId'] = this.roomId;
    data['text'] = this.text;
    data['datetime'] = this.datetime;
    return data;
  }
}