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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _getComments);
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
              SizedBox(
                height: 200.0,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    enableInfiniteScroll: true,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: widget.point.photos.map((url) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        url.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
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
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _comments[index].userName,
                            style: const TextStyle(fontSize: 12),
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
            SafeArea(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Agrega un comentario...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getComments() async {
    _comments = await CommentService.get(widget.point.id);
    setState(() {});
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
      userName: '',
      created: null,
    );

    await CommentService.add(comment);

    _commentController.text = '';
    setState(() {});

    _getComments();
  }
}
