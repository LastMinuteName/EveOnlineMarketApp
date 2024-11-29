import 'package:flutter/material.dart';

Widget centeredCircularProgressIndicator() {
  return const Center(
      child: SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      )
  );
}