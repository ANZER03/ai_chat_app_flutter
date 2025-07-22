import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.transparent,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
          child: Markdown(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            data: message,
            styleSheet: MarkdownStyleSheet(
              p: GoogleFonts.inter(
                fontSize: 14,
                color: const Color.fromARGB(221, 0, 0, 0),
              ),
              listBullet: GoogleFonts.inter(
                fontSize: 14,
                color: const Color.fromARGB(221, 0, 0, 0),
              ),
              code: GoogleFonts.sourceCodePro(
                backgroundColor: Colors.grey[200],
                color: Colors.black,
              ),
            ),
            // builders: {
            //   'code': CodeElementBuilder(),
            // },
          ),
        ),
      ),
    );
  }
}