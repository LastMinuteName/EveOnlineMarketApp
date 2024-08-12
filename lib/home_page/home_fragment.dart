import 'package:flutter/material.dart';

class HomeFragment extends StatefulWidget{
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _MyHomeFragmentState();
}

class _MyHomeFragmentState extends State<HomeFragment>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Home"),
    );
  }
}