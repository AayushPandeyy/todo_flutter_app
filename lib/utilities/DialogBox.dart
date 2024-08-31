import 'package:flutter/material.dart';

class DialogBox{
void showPopup(BuildContext context, String text, title) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(text),
          ));
}
}