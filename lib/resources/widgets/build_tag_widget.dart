import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';

class BuildTagWidget extends StatelessWidget {
  final String text;
  const BuildTagWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30.0,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white.withAlpha(120),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.commonstyle
                .copyWith(color: Colors.white, fontSize: 12.0),
          ),
        ),
      ),
    );
  }
}
