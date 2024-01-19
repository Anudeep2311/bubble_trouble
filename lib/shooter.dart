import 'package:flutter/material.dart';

class Shooter extends StatelessWidget {
  const Shooter({
    super.key,
    this.shootX,
    this.height,
  });
  final shootX;
  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(shootX, 1),
      child: Container(
        width: 2,
        height: height,
        color: Colors.grey,
      ),
    );
  }
}
