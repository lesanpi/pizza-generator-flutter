import 'package:flutter/material.dart';

class PizzaSendButton extends StatelessWidget {
  final size = 50;
  const PizzaSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent,
              Colors.blueAccent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 10.0),
              spreadRadius: 2.0,
              blurRadius: 10.0,
            )
          ]),
      child: Icon(
        Icons.send,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
