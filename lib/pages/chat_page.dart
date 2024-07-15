import 'package:chatapp/componenets/chat_bubble.dart';
import 'package:chatapp/componenets/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //* text controller
  final TextEditingController _messageController = TextEditingController();

  //*chat & auth services
  final ChatService _chatSevice = ChatService();

  final AuthService _authService = AuthService();

  //*for textfiled Focus
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    //* add listener to focus node
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        //* cause a delay so that the keyboard has time to show up
        //* then the amount of reamaining space wiil be calculated,
        //* the scroll down
        Future.delayed(const Duration(milliseconds: 500),() => scrollDown());
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //* scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  //*send meesage
  void sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _chatSevice.sendMessage(widget.receiverId, _messageController.text);

      //* clear text controller
      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:  Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput()
        ],
      ),
    );
  }

  //* build meesage list
  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(stream: _chatSevice.getMessages(widget.receiverId, senderId), builder: ((context, snapshot) {
        //*errors
        if(snapshot.hasError){
          return const Text("Error");
        }
        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading...");
        }
        //* return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
    }));
  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data = doc.data() as Map<String, dynamic>;
    //*is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    var allignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    //*allign message to ther right if sender is the current user
    return Container(
      alignment: allignment,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isCurrentUser? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          //Text(data["message"]),
          //Text(isCurrentUser.toString())
          ChatBubble(isCurrentUser : isCurrentUser, message: data['message'])
        ]),
    );
  }

  //* build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //* textfield should take up most of the space 
          Expanded(
            child: MyTextField(
              foucusNode: myFocusNode,
              controller: _messageController,
              hintText: 'Type A message',
              obscureText: false,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}