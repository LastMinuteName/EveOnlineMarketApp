import 'package:flutter/material.dart';

class InvTypeStatList extends StatefulWidget {
  final int typeID;
  const InvTypeStatList({super.key, required this.typeID});

  @override
  State<InvTypeStatList> createState() => _InvTypeStatListState();
}

class _InvTypeStatListState extends State<InvTypeStatList> {
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