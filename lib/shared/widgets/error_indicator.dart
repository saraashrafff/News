import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  ErrorIndicator([this.messege = 'Something went wrong']);
  String messege;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(messege));
  }
}
