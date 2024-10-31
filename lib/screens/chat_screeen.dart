import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatScreeen extends StatefulWidget {
  static const id = 'chat_screen';
  const ChatScreeen({super.key});

  @override
  State<ChatScreeen> createState() => _ChatScreeenState();
}

class _ChatScreeenState extends State<ChatScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.person),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // Implement logout functionality
                // print('Log Out');
              },
              icon: Icon(Icons.close))
        ],
        title: Center(child: Text('⚡️Chat')),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      // Do something with the user input
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
