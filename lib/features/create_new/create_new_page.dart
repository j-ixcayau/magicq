import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:magiq/features/main_map/main_map_page.dart';
import 'package:magiq/model/category.dart';
import 'package:magiq/model/photo.dart';
import 'package:magiq/model/point.dart';
import 'package:magiq/utils/http/category.dart';
import 'package:magiq/utils/http/photo.dart';
import 'package:magiq/utils/http/point.dart';
import 'package:magiq/utils/upload_image.dart';

class CreateNewPage extends StatefulWidget {
  final LatLng position;

  const CreateNewPage({
    super.key,
    required this.position,
  });

  @override
  State<CreateNewPage> createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<(XFile, Uint8List)> photos = []; // Store multiple selected photos

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  Category? selectedType;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _init);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Agregar Noticia'),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Category>(
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Selecciona la categoría'),
                      ),
                      value: selectedType,
                      items: categories.map(
                        (category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(category.name),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (newValue) {
                        selectedType = newValue;
                        setState(() {});
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed:
                            _showImageSourceSelection, // Show bottom sheet
                        child: const Text('Seleccionar Imágenes'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (photos.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            '${photos.length} imagen(es) seleccionada(s)'), // Display the count of selected images
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Preview selected images
                photos.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.memory(
                                photos[index].$2,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    : Container(), // Empty container if no images are selected

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAddMarker,
                        child: const Text('Agregar'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black38.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
      ],
    );
  }

  void _init() async {
    categories = await CategoryService.get();

    setState(() {});
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Seleccionar de la Galería'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFiles = await _picker.pickImage(source: source);
      if (pickedFiles == null) {
        return;
      }

      final info = (pickedFiles, await pickedFiles.readAsBytes());

      photos.add(info);
      setState(() {});
    } catch (e) {
      // Handle error if needed
      print('Error picking images: $e');
    }
  }

  void onAddMarker() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios')),
      );
      return;
    }

    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay imagenes para agregar')),
      );
      return;
    }

    try {
      isLoading = true;
      setState(() {});

      final point = Point(
          id: 0,
          title: titleController.text,
          description: descriptionController.text,
          location: widget.position,
          categoryId: selectedType!.id,
          status: 'Activo',
          link: '',
          userId: MainMapPage.userId,
          photos: []);

      final result = await PointService.create(point);

      if (result == null) {
        resetStatus();
        return;
      }
      point.id = result;

      final uploadedImageUrls = await UploadImage.uploadImages(photos);

      for (var it in uploadedImageUrls) {
        final photo = Photo(
          id: 0,
          url: it,
          pointId: point.id,
          markerId: null,
        );

        await PhotoService.create(photo);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print('Error uploading images: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload images')),
      );
    } finally {
      resetStatus();
    }
  }

  void resetStatus() {
    isLoading = false;
    setState(() {});
  }
}
