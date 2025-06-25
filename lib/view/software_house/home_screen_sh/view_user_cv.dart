import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';

class ViewUserCv extends StatelessWidget {
  final String pdfUrl;

  const ViewUserCv({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whitecolor),
        title: Text(
          "User Resume",
          style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
        ),
        backgroundColor: themecolor,
        centerTitle: true,
      ),
      body: pdfUrl.isEmpty
          ? Center(
              child: Text("No Resume Found", style: AppTextStyle.commonstyle),
            )
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                    "https://docs.google.com/gview?embedded=true&url=$pdfUrl"),
              ),
            ),
    );
  }
}
