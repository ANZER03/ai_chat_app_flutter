import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        50,
      ), // Exact padding from your code
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
          padding: const EdgeInsets.fromLTRB(
            4,
            1,
            4,
            1,
          ), // Exact padding from your code
          child: MarkdownBody(
            selectable: true, // Enables text selection for copying
            data: message,
            builders: {},
            onTapLink: (text, href, title) async {
              if (href == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No link provided')),
                );
                return;
              }

              String url = href;
              // Add scheme if missing (e.g., convert "www.google.com" to "https://www.google.com")
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                url = 'https://$url';
              }

              try {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cannot launch URL: $url')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid URL format: $url')),
                );
              }
            },
            styleSheet: MarkdownStyleSheet(
              // Paragraph text
              p: GoogleFonts.inter(
                fontSize: 16,
                color: const Color.fromARGB(221, 33, 33, 33),
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              // Headers
              h1: GoogleFonts.inter(
                fontSize: 28,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              h2: GoogleFonts.inter(
                fontSize: 24,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              h3: GoogleFonts.inter(
                fontSize: 20,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              h4: GoogleFonts.inter(
                fontSize: 18,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              // Links
              a: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
              ),
              // Code blocks and inline code
              code: GoogleFonts.sourceCodePro(
                fontSize: 14,
                color: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: Colors.grey[200],
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
              // Blockquote
              blockquote: GoogleFonts.inter(
                fontSize: 16,
                color: const Color.fromARGB(221, 50, 50, 50),
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
              // List bullets
              listBullet: GoogleFonts.inter(
                fontSize: 16,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w500,
              ),
              // Ordered list
              orderedListAlign: WrapAlignment.start,
              // Table
              tableHead: GoogleFonts.inter(
                fontSize: 16,
                color: const Color.fromARGB(221, 0, 0, 0),
                fontWeight: FontWeight.w600,
                backgroundColor: Colors.grey[100],
              ),
              tableBody: GoogleFonts.inter(
                fontSize: 14,
                color: const Color.fromARGB(221, 33, 33, 33),
                fontWeight: FontWeight.w400,
              ),
              tableBorder: TableBorder.all(
                color: const Color.fromARGB(221, 150, 150, 150),
                width: 1,
              ),
              // Horizontal rule
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                    width: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
