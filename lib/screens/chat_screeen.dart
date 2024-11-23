import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;

class ChatScreeen extends StatefulWidget {
  static const id = 'chat_screen';
  const ChatScreeen({super.key});

  @override
  State<ChatScreeen> createState() => _ChatScreeenState();
}

class _ChatScreeenState extends State<ChatScreeen> {
  bool _isLoggedIn = false;
  String? message;
  TextEditingController textFieldController = TextEditingController();
  // Stream messageStream = db.collection('chat_records').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoggedInUser();
    });
  }

  void getLoggedInUser() {
    setState(() {
      _isLoggedIn = user != null;
    });
    if (!_isLoggedIn) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  void sendMessage() {
    if (message != null && message!.isNotEmpty) {
      Map<String, dynamic> data = {
        'user': user!.email,
        'message': message,
        'timestamp': Timestamp.now()
      };
      db.collection('chat_records').add(data);
    }
  }

  void messagesStream() async {
    print("Getting snapshots");
    await for (var snapshot in db.collection('chat_records').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
    // final docRef = db.collection('messages')
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoggedIn
        ? SizedBox.shrink()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: Icon(Icons.person),
              actions: <Widget>[
                IconButton(
                    onPressed: () async {
                      // Implement logout functionality
                      // print('Log Out');
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
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
                Text(
                  'Hello',
                  style: kSendButtonTextStyle,
                ),
                Text(
                  'World',
                  style: kSendButtonTextStyle,
                ),
                TextBoxesListView(),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textFieldController,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: (value) {
                            // Do something with the user input
                            message = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                          textFieldController.clear();
                          // messagesStream();
                          setState(() {
                            // message = '';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Send',
                            style: kSendButtonTextStyle,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          );
  }
}

class TextBoxesListView extends StatefulWidget {
  const TextBoxesListView({super.key});

  @override
  State<TextBoxesListView> createState() => _TextBoxesListViewState();
}

class _TextBoxesListViewState extends State<TextBoxesListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('chat_records').orderBy('timestamp').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        List<Widget> _data = [];
        var messages = snapshot.data!;
        for (var value in messages.docs) {
          var data = value.data() as Map<String, dynamic>;
          final text = data['message'];
          final sender = data['user'];

          _data.add(
            TextBubble(sender: sender, text: text),
          );
        }
        return Expanded(
          child: ListView(
            children: _data,
          ),
        );
      },
    );
  }
}

class TextBubble extends StatelessWidget {
  TextBubble({
    super.key,
    required this.sender,
    required this.text,
  });

  final String sender;
  final String text;
  late Color color =
      user!.email == sender ? Colors.lightBlueAccent : Colors.blueGrey;
  late BorderRadius senderRadius = BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.zero,
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25));
  late BorderRadius receiverRadius = BorderRadius.only(
      topRight: Radius.circular(25),
      topLeft: Radius.zero,
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: user!.email == sender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: Text(
              sender.split('@')[0].capitalize(),
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: user!.email == sender ? senderRadius : receiverRadius,
            color: color,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 13),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
