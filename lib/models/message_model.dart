class MessageModel {
  String? id;
  String? title;
  String? content;
  String? date;
  String? time;
  String? phone;
  num? timestamp;
  bool? isViewed;

  MessageModel({this.id, this.title, this.content, this.date, this.time, this.isViewed, this.timestamp,this.phone});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    time = json['time'];
    phone = json['phone'];
    isViewed = json['isViewed'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['time'] = this.time;
    data['phone'] = this.phone;
    data['isViewed'] = this.isViewed;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
