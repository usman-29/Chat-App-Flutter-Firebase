import 'package:chat_app/models/chat_users.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// static objects
class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for storing current user information
  static late ChatUser me;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking if current user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for getting current user info
  static Future<void> getUserInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getAllUsers());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      about: 'Available',
      name: user.displayName.toString(),
      createdAt: time,
      isOnline: false,
      id: user.uid.toString(),
      lastActive: time,
      email: user.email.toString(),
      pushToken: '',
    );
    // below code converts chatUser into json format and makes a new user id document save that json data in it and then save that document in users collection
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson()));
  }

  // for getting all users from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating using information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // getting unique conversation id from two ids
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // chat screen
  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return APIs.firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    // message sending time used for doc id
    final time = DateTime.now().toString();

    // message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
