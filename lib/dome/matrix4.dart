import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'dart:math';

class Marie41 extends StatelessWidget {

  final v.Vector3 scale = v.Vector3(0.5, 1, 1);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('images/1.jpeg'),
    );
  }
}
