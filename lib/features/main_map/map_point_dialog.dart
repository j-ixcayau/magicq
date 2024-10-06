import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:magiq/model/photo.dart';

void showCustomDialog(
  BuildContext context,
  String title,
  String? description,
  List<Photo> imageUrls,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (description != null) ...[
                Text(description),
                const SizedBox(height: 8.0),
              ],
              const SizedBox(height: 8.0),
              const Text(
                'Photos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (imageUrls.isEmpty)
                const Text('No hay imágenes para mostrar')
              else
                SizedBox(
                  height: 200.0, // Constrain height for the Carousel
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                    items: imageUrls.map(
                      (url) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                            url.url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
