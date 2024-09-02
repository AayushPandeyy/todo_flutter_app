import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String placeholder;
  final String? title;
  const CustomTextField(
      {super.key, this.controller, required this.placeholder, this.title});

  @override
  Widget build(BuildContext context) {
    if (controller != null && title != null) {
      controller!.text = title!;
    } else {}
    return TextField(
      style: const TextStyle(color: Colors.red),
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.pink,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.grey[400],
          ),
          onPressed: () {
            controller!.text = "";
          },
        ),
      ),
    );
  }
}
