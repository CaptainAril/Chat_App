import 'package:flutter/material.dart';

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
    border: Border(
  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
));

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

final Map<String, Color> colorMap = {
  'a': Colors.red,
  'b': Colors.blue,
  'c': Colors.green,
  'd': Colors.yellow,
  'e': Colors.orange,
  'f': Colors.purple,
  'g': Colors.pink,
  'h': Colors.brown,
  'i': Colors.cyan,
  'j': Colors.lime,
  'k': Colors.indigo,
  'l': Colors.teal,
  'm': Colors.amber,
  'n': Colors.grey,
  'o': Colors.blueGrey,
  'p': Colors.lightBlue,
  'q': Colors.lightGreen,
  'r': Colors.limeAccent,
  's': Colors.orangeAccent,
  't': Colors.deepOrange,
  'u': Colors.deepPurple,
  'v': Colors.deepOrangeAccent,
  'w': Colors.pinkAccent,
  'x': Colors.purpleAccent,
  'y': Colors.tealAccent,
  'z': Colors.yellowAccent,
};
