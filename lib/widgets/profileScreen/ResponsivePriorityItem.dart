import 'package:flutter/material.dart';

class ResponsivePriorityItem extends StatelessWidget {
  final String priorityText;
  final String count;
  final Color color;

  const ResponsivePriorityItem({
    required this.priorityText,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.005,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Row(
            children: [
              Text(count),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(priorityText),
            ],
          ),
        ),
      ),
    );
  }
}
