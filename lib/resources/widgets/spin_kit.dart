import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SpinkitLoading extends StatelessWidget {
  const SpinkitLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.halfTriangleDot(
      color: Colors.deepPurple,
      size: 70.0,
    ));
  }
}
