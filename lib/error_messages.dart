import "package:flutter/material.dart";
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ErrorMessage {
  final String message;
  final String msgTitle;
  final Color color;
  final ContentType contentType;

  const ErrorMessage(
      {required this.msgTitle,
      required this.message,
      required this.color,
      required this.contentType});

  static show(BuildContext context, String msgTitle, String message,
      ContentType contentType, Color color) {
    double screenHeight = MediaQuery.of(context).size.height;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        content: AwesomeSnackbarContent(
          title: msgTitle,
          message: message,
          messageFontSize: 18,
          contentType: contentType,
          color: color,
          //inMaterialBanner: ,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.only(bottom: screenHeight * 0.77),
      ),
    );
  }
}
