import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMessage extends StatelessWidget {
  final String message;

  const UserMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color.fromARGB(234, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}