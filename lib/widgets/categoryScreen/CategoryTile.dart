import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String category;
  const CategoryTile({super.key, required this.icon, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: MediaQuery.sizeOf(context).width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            category,
            style:const TextStyle(
                fontSize: 20,
                fontFamily: "MarkoOne",
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
