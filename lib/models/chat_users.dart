// chat user class
class ChatUser {
  // constructor
  ChatUser({
    required this.image,
    required this.name,
    required this.id,
    required this.email,
    required this.pushToken,
  });
  // fields
  late String image; // user image
  late String name; // user name
  late String id; // user id
  late String email; // user email
  late String pushToken; // for notifications

  // json to object converter
  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  // object to json converter
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
