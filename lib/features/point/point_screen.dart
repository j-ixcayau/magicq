import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:magiq/features/main_map/main_map_page.dart';
import 'package:magiq/model/comment.dart';
import 'package:magiq/model/point.dart';
import 'package:magiq/utils/http/comment.dart';

class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    super.key,
    required this.point,
  });

  final Point point;

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.point.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.point.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Fotos:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            if (widget.point.photos.isEmpty)
              const Text('No images to display.')
            else
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        // Update current index if needed
                      });
                    },
                  ),
                  items: widget.point.photos.map((url) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        url.url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24.0),
            const Text(
              'Comentarios:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _comments[index].userName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _comments[index].content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                if (_comments[index].created != null)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      _comments[index].formattedDate,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Agrega un comentario...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _addComment,
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getComments() async {
    setState(() {
      _isLoading = true;
    });

    _comments = await CommentService.get(widget.point.id);

    setState(() {
      _isLoading = false;
    });
  }

  void _addComment() async {
    if (_commentController.text.isEmpty) {
      return;
    }

    final comment = Comment(
      id: 0,
      content: _commentController.text.trim(),
      userId: MainMapPage.userId,
      pointId: widget.point.id,
      userName: '', // Get actual user name if available
      created: null,
    );

    await CommentService.add(comment);
    _commentController.clear();
    _getComments(); // Refresh comments
  }
}
