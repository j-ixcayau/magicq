import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class CuriosityPage extends StatelessWidget {
  final String info;

  const CuriosityPage({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curiosidades'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: info,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(fontSize: 16.0),
            h1: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            h2: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            h3: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            blockquote: TextStyle(
                color: Colors.grey.shade600, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
