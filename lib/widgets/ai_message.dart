import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AiMessage extends StatefulWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  State<AiMessage> createState() => _AiMessageState();
}

class _AiMessageState extends State<AiMessage> {
  bool _isLiked = false;
  bool _isDisliked = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage() {
    Share.share(widget.message, subject: 'AI Response');
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked)
        _isDisliked = false; // Can't like and dislike at the same time
    });
  }

  void _toggleDislike() {
    setState(() {
      _isDisliked = !_isDisliked;
      if (_isDisliked)
        _isLiked = false; // Can't like and dislike at the same time
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
              child: MarkdownBody(
                selectable: true,
                data: widget.message,
                builders: {},
                onTapLink: (text, href, title) async {
                  if (href == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No link provided')),
                    );
                    return;
                  }

                  String url = href;
                  if (!url.startsWith('http://') &&
                      !url.startsWith('https://')) {
                    url = 'https://$url';
                  }

                  try {
                    final Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
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
                  p: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(221, 33, 33, 33),
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
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
                  a: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  ),
                  code: GoogleFonts.sourceCodePro(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: Colors.grey[200],
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                  blockquote: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(221, 50, 50, 50),
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                  listBullet: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500,
                  ),
                  orderedListAlign: WrapAlignment.start,
                  tableColumnWidth: const IntrinsicColumnWidth(),
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
                  tablePadding: const EdgeInsets.all(8),
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
        ),
        // Fixed Action Icons Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Copy Icon
              GestureDetector(
                onTap: _copyToClipboard,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.copy, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              // Share Icon
              GestureDetector(
                onTap: _shareMessage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.share, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              // Like Icon
              GestureDetector(
                onTap: _toggleLike,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 20,
                    color: _isLiked
                        ? const Color.fromARGB(255, 85, 84, 84)
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Dislike Icon
              GestureDetector(
                onTap: _toggleDislike,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                    size: 20,
                    color: _isDisliked
                        ? const Color.fromARGB(255, 85, 84, 84)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
