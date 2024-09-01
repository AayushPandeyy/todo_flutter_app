import 'package:flutter/material.dart';

class TodoCard extends StatefulWidget {
  final String task;
  const TodoCard({super.key, required this.task});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.yellow),
      child: Row(
        children: [
          Checkbox(
            value: completed,
            onChanged: (value) {
              setState(() {
                completed = value!;
              });
            },
            checkColor: Colors.yellow,
            activeColor: Colors.black,
          ),
          Text(
            widget.task,
            style: const TextStyle(
                fontFamily: "Gabarito",
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
