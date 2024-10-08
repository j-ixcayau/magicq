import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  String? selectedType;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<(XFile, Uint8List)> photos = []; // Store multiple selected photos

  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

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
                    child: DropdownButton<String>(
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Selecciona la categoría'),
                      ),
                      value: selectedType,
                      items: [
                        'Anuncio a la comunidad',
                        'Reporte ambiental',
                        'Violencia',
                        'Emergencias nacionales',
                        'Obras públicas',
                        'Anuncios de Canales',
                      ].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(type),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedType = newValue;
                        });
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
    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay imagenes para agregar')),
      );
      return;
    }

    try {
      isLoading = true;
      setState(() {});

      final uploadedImageUrls = await UploadImage.uploadImages(photos);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error uploading images: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload images')),
      );
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
