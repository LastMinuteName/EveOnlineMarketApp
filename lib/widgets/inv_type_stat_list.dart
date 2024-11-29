import 'package:flutter/material.dart';

class InvTypetatList extends StatefulWidget {
  final int typeID;
  const InvTypetatList({super.key, required this.typeID});

  @override
  State<InvTypetatList> createState() => _InvTypetatListState();
}

class _InvTypetatListState extends State<InvTypetatList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([

      ]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Placeholder();
      }
    );
  }
}