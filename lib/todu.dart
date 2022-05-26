import 'package:flutter/material.dart';
import 'package:todo/notes.dart';

class ToduOp extends StatefulWidget {
  // var descrption;

  const ToduOp({Key? key, required this.title}) : super(key: key);

  final String title;

  // String title, descrption;
  // final int total;
  //final NotesModel;
  @override
  State<ToduOp> createState() => _ToduOpState();

  //  String title,descrption;
}

class _ToduOpState extends State<ToduOp> {
  get title => title;
  // late String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text('$title')),
          //Text('data'),
        ],
      ),
    );
  }
}

class $ {}
