import 'package:flutter/material.dart';

class MoreFragment extends StatefulWidget{
  const MoreFragment({super.key});

  @override
  State<MoreFragment> createState() => _MyMoreFragmentState();
}

class _MyMoreFragmentState extends State<MoreFragment>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("More"),
    );
  }
}