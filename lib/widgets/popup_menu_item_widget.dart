import 'package:flutter/material.dart';

PopupMenuItem<String> buildPopupMenuItem({
  required String value,
  required String title,
  required String description,
  required String selectedModel,
}) {
  return PopupMenuItem<String>(
    value: value,
    child: Container(
      width: 500,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            Visibility(
              visible: selectedModel == value,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(Icons.task_alt, color: Colors.black, size: 19),
            ),
          ],
        ),
      ),
    ),
  );
}