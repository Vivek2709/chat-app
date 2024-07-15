import 'package:chatapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({super.key,required this.isCurrentUser,required this.message});

  @override
  Widget build(BuildContext context) {
    //* light vs dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser? (isDarkMode? Colors.green.shade600 : Colors.grey.shade500) : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200),
        borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      padding: EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      child: Text(
        message,
        style: TextStyle(
          color: isCurrentUser ? Colors.white : (isDarkMode? Colors.white : Colors.black)
        ),
        
        ),
    );
  }
}