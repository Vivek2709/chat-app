import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //* get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //*get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //* go through each individual user
        final user = doc.data();

        //* return user
        return user;
      }).toList();
    });
  }

  //* send message
  Future<void> sendMessage(String receiverId, message) async {
    //* get current user info
    final String currenUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //* createt a new message
    Message newMessage = Message(
        senderId: currenUserID,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);
    //*construct chat room ID fo the two users(sorted so ensure uniqueness)
    List<String> ids = [currenUserID, receiverId];
    ids.sort(); //* sort the ids (this ensure chatroomId is the same for any 2 people)
    String chatRoomId = ids.join('_');
    //*add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //* get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    //*construct a chatroom id for the two users;
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
