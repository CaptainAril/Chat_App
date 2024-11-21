import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class ChatScreeen extends StatefulWidget {
  static const id = 'chat_screen';
  const ChatScreeen({super.key});

  @override
  State<ChatScreeen> createState() => _ChatScreeenState();
}

class _ChatScreeenState extends State<ChatScreeen> {
  bool _isLoggedIn = false;
  String? message;
  User? user;
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
    user = FirebaseAuth.instance.currentUser;
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
                TextBoxes(),
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

class TextBoxes extends StatefulWidget {
  const TextBoxes({super.key});

  @override
  State<TextBoxes> createState() => _TextBoxesState();
}

class _TextBoxesState extends State<TextBoxes> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('chat_records').snapshots(),
      builder: (BuildContext context, snapshot) {
        List<Widget> _data = [];
        var messages = snapshot.data!;
        for (var value in messages!.docs) {
          var data = value.data() as Map<String, dynamic>;
          final text = data['message'];
          final sender = data['user'];

          _data.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: Text(
                      sender,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 35),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
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
