// Enhanced markdown rendering for Hermes Android.
// Improves code blocks, tables, blockquotes, lists, and links.
// Addresses Issue #12: Markdown Rendering Improvements.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enhanced markdown stylesheet for Hermes chat messages.
///
/// Features:
/// - Code blocks with dark background, rounded corners, and copy button
/// - Tables with borders, header background, and alternating row colors
/// - Blockquotes with left border and subtle background
/// - Tappable links
/// - Better list indentation and bullet styling
MarkdownStyleSheet hermesMarkdownStyleSheet(BuildContext context, {required bool isUser}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  // Color palette
  final codeBgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
  final codeBorderColor = isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0);
  final tableBorderColor = isDark ? const Color(0xFF4A4A4A) : const Color(0xFFDDDDDD);
  final blockquoteBg = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4FF);
  final linkColor = isDark ? const Color(0xFF82B1FF) : const Color(0xFF1976D2);

  return MarkdownStyleSheet(
    // Paragraph
    p: TextStyle(
      fontSize: 15,
      height: 1.5,
      color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
    ),

    // Headings
    h1: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black),
      height: 1.3,
    ),
    h2: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black),
      height: 1.3,
    ),
    h3: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      height: 1.3,
    ),
    h4: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      height: 1.3,
    ),

    // Emphasis
    em: TextStyle(
      fontStyle: FontStyle.italic,
      color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
    ),
    strong: TextStyle(
      fontWeight: FontWeight.bold,
      color: isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
    ),

    // Inline code
    code: TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      backgroundColor: (isUser ? Colors.white : Colors.black).withValues(alpha: 0.12),
      color: isUser ? Colors.white : (isDark ? const Color(0xFFE06C75) : const Color(0xFFD32F2F)),
    ),

    // Code block decoration
    codeblockDecoration: BoxDecoration(
      color: codeBgColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: codeBorderColor, width: 1),
    ),
    codeblockPadding: const EdgeInsets.all(12),

    // Blockquote
    blockquote: TextStyle(
      fontStyle: FontStyle.italic,
      color: isUser ? Colors.white60 : (isDark ? Colors.grey[400] : Colors.grey[700]),
      fontSize: 14,
      height: 1.5,
    ),
    blockquoteDecoration: BoxDecoration(
      color: isUser ? Colors.white.withValues(alpha: 0.1) : blockquoteBg,
      borderRadius: BorderRadius.circular(6),
      border: Border(
        left: BorderSide(
          color: isUser ? Colors.white38 : theme.colorScheme.primary,
          width: 3,
        ),
      ),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

    // Links
    a: TextStyle(
      color: isUser ? Colors.white70 : linkColor,
      decoration: TextDecoration.underline,
      decorationColor: isUser ? Colors.white38 : linkColor,
    ),

    // Lists
    listBullet: TextStyle(
      color: isUser ? Colors.white70 : theme.colorScheme.primary,
      fontSize: 14,
    ),
    listIndent: 24,
    listBulletPadding: const EdgeInsets.only(right: 8),

    // Horizontal rule
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
    ),

    // Table styling
    tableHead: TextStyle(
      fontWeight: FontWeight.bold,
      color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
      fontSize: 14,
    ),
    tableBody: TextStyle(
      color: isUser ? Colors.white70 : (isDark ? Colors.white70 : Colors.black87),
      fontSize: 14,
    ),
    tableBorder: TableBorder.all(
      color: tableBorderColor,
      width: 1,
    ),
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    tableHeadAlign: TextAlign.left,

    // Spacing
    h1Padding: const EdgeInsets.only(top: 16, bottom: 8),
    h2Padding: const EdgeInsets.only(top: 14, bottom: 6),
    h3Padding: const EdgeInsets.only(top: 12, bottom: 4),
    pPadding: const EdgeInsets.only(bottom: 8),
  );
}

/// Custom markdown builder for code blocks with copy button.
class HermesCodeBlockBuilder extends MarkdownElementBuilder {
  final bool isUser;

  HermesCodeBlockBuilder({required this.isUser});

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    // Extract code content
    final code = element.textContent;
    if (code.trim().isEmpty) return null;

    // Extract language from class attribute
    String? language;
    if (element.attributes.containsKey('class')) {
      language = element.attributes['class']?.replaceFirst('language-', '');
    }

    return _CodeBlockWidget(
      code: code,
      language: language,
      isUser: isUser,
    );
  }
}

class _CodeBlockWidget extends StatefulWidget {
  final String code;
  final String? language;
  final bool isUser;

  const _CodeBlockWidget({
    required this.code,
    this.language,
    required this.isUser,
  });

  @override
  State<_CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<_CodeBlockWidget> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final codeBgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final codeBorderColor = isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE0E0E0);
    final codeTextColor = isDark ? const Color(0xFFABB2BF) : const Color(0xFF383A42);
    final langBgColor = isDark ? const Color(0xFF3E3E3E) : const Color(0xFFE8E8E8);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: codeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: codeBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Language label + copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: langBgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
              border: Border(
                bottom: BorderSide(color: codeBorderColor, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.language ?? 'code',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                ),
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _copied ? Icons.check : Icons.copy,
                        size: 14,
                        color: _copied
                            ? const Color(0xFF4CAF50)
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _copied ? 'Copied!' : 'Copy',
                        style: TextStyle(
                          fontSize: 11,
                          color: _copied
                              ? const Color(0xFF4CAF50)
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              widget.code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
                color: codeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tappable link widget for markdown links.
class TappableLink extends StatelessWidget {
  final String text;
  final String href;

  const TappableLink({
    required this.text,
    required this.href,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final linkColor = isDark ? const Color(0xFF82B1FF) : const Color(0xFF1976D2);

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(href);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: linkColor,
          decoration: TextDecoration.underline,
          decorationColor: linkColor,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}
