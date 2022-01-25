import 'package:flutter/material.dart';

class PizzaSendButton extends StatefulWidget {
  final VoidCallback onTap;
  const PizzaSendButton({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PizzaSendButton> createState() => _PizzaSendButtonState();
}

class _PizzaSendButtonState extends State<PizzaSendButton>
    with SingleTickerProviderStateMixin {
  final size = 50;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.1,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animateButton();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: //(2 - Curves.easeOut.transform(_animationController.value)),
                (2 - _animationController.value),
            // (1 - _animationController.value).clamp(0.75, 1.0)
            child: child!,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blueAccent,
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 10.0),
                  spreadRadius: 2.0,
                  blurRadius: 10.0,
                )
              ]),
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}
